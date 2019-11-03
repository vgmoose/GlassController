import Foundation
import AppKit
import Cocoa

// initialize the application
NSApplication.shared()

// hide the dock icon (same as LSUIElement true in Info.plist)
NSApp.setActivationPolicy(.accessory)

// We have to generate everything programatically for the private touchpad API
// callback to work properly (I don't know why this is)

// the window that will house the glassview
var previewWindow: NSWindow?

// the glass touchpad preview view
let frameRect = NSMakeRect(0, 0, 800, 450)
let view = GlassView(frame: frameRect)
let glassView = view

var enabledMenuButton = NSMenuItem(title: "Enable GlassCon", action: #selector(GlassPreferences.toggleGlass), keyEquivalent: "")

var profileItems: [NSMenuItem] = []

var glassEnabled = true

func showPreviewWindow()
{
    // window already being displayed, return
    if previewWindow != nil { return }
    
    let window = NSWindow(contentRect: frameRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    previewWindow = window;

    view.isHidden = false
    view.needsDisplay = true
    window.contentView = view
	
    window.cascadeTopLeft(from: NSMakePoint(20, 20))
    window.title = "Touchpad Preview"
    window.makeKeyAndOrderFront(nil)
}

func getActivationState() -> NSControlStateValue
{
    if glassEnabled
    {
        return NSOnState
    }
    
    return NSOffState
}

func setupMenuBar()
{
    // create some status bar entries
    var app = NSApplication.shared()
    
    var menuBar = NSMenu()
    var appMenuItem = NSMenuItem()
    menuBar.addItem(appMenuItem)
    app.mainMenu = menuBar
    
    var appMenu = NSMenu()
    
    enabledMenuButton.state = getActivationState()
    enabledMenuButton.target = GlassPreferences.self
    appMenu.addItem(enabledMenuButton)
    
    let preferencesButton = NSMenuItem(title: "Preferences", action: #selector(GlassPreferences.showConfigWindow), keyEquivalent: "")
    preferencesButton.target = GlassPreferences.self
    appMenu.addItem(preferencesButton)

//    let previewButton = NSMenuItem(title: "Touchpad Preview", action: #selector(glassView.showGlass), keyEquivalent: "")
//    previewButton.target = glassView
//    appMenu.addItem(previewButton)
	
	appMenu.addItem(NSMenuItem.separator())
	
	let selectors = [#selector(GlassPreferences.switchProfile1),
					 #selector(GlassPreferences.switchProfile2),
					 #selector(GlassPreferences.switchProfile3)]
	
	for x in 0..<3 {
		let item = NSMenuItem(title: GlassPreferences.slotNames[x], action: selectors[x], keyEquivalent: "")
		item.target = GlassPreferences.self
		profileItems.append(item)
		appMenu.addItem(item)
	}
	
	appMenu.addItem(NSMenuItem.separator())
    
    appMenu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: ""))
    appMenuItem.submenu = appMenu
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    statusItem.title = "🔳"
    statusItem.menu = appMenu
}

// start touch listener for touchpad event
let dev = MTDeviceCreateDefault()
MTRegisterContactFrameCallback(dev, processTouchpadData);
MTDeviceStart(dev, 0);

setupMenuBar()

GlassPreferences.showConfigWindow()
//glassView.showGlass()

GlassPreferences.loadProfileSlots()

NSApp.activate(ignoringOtherApps: true)
NSApp.run()
