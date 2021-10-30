import Foundation
import AppKit
import Cocoa

//@NSApplicationMain
class GlassDelegate : NSObject, NSApplicationDelegate
{
	static var glassView: GlassView?
	static var singleton: GlassDelegate?
	
	// the window that will house the glassview
	var previewWindow: NSWindow?

	// the glass touchpad preview view
	let frameRect = NSMakeRect(0, 0, 800, 450)
	var view: GlassView?
	
	var enabledMenuButton = NSMenuItem(title: "Enable GlassCon", action: #selector(GlassPreferences.toggleGlass), keyEquivalent: "")

	var profileItems: [NSMenuItem] = []

	var glassEnabled = true
	
	var menuBar: NSMenu?
	var statusItem: NSStatusItem?
	
	override init(){
		super.init()
		GlassDelegate.singleton = self
		view = GlassView(frame: frameRect)

		let frameRect = NSMakeRect(0, 0, 800, 450)
		GlassDelegate.glassView = GlassView(frame: frameRect)
		
		// start touch listener for touchpad event
		if let devices = MTDeviceCreateList() {
			for x in 0..<devices.count {
				let dev = devices[x] as MTDevice
				MTRegisterContactFrameCallback(dev, processTouchpadData)
				let res = MTDeviceStart(dev, 0)
				if res != 0 {
					// TODO: warn in the UI
					print("There was an issue initializing touchpad #\(x)... \(res)")
				}
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showPreviewWindow()
	{
		// window already created, show it
		if let pw = previewWindow {
			pw.makeKeyAndOrderFront(nil)
			return
		}
		
		let window = NSWindow(contentRect: frameRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
		previewWindow = window;

		window.isReleasedWhenClosed = false

		view!.isHidden = false
		view!.needsDisplay = true
		window.contentView = view!
		
		window.cascadeTopLeft(from: NSMakePoint(20, 20))
		window.title = "Touchpad Preview"
		window.makeKeyAndOrderFront(nil)
	}

	func getActivationState() -> NSControl.StateValue
	{
		if glassEnabled
		{
			return  NSControl.StateValue.on
		}
		
		return  NSControl.StateValue.off
	}

	func setupMenuBar()
	{
		menuBar = NSApplication.shared.mainMenu
		let appMenuItem = NSMenuItem()
		menuBar!.addItem(appMenuItem)

		let appMenu = NSMenu()
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


		let item = NSMenuItem(title: "Restart", action: #selector(GlassPreferences.restartListeners), keyEquivalent: "")
		item.target = GlassPreferences.self
		appMenu.addItem(item)

		appMenu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: ""))

		appMenuItem.submenu = appMenu
		
		statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		statusItem!.button!.title = "🔳"
		statusItem!.button!.sizeToFit()
		statusItem!.isVisible = true
		statusItem!.menu = appMenu
		
	}

	func applicationDidFinishLaunching(_ notification: Notification)
	{
		GlassDelegate.glassView = view
		
		setupMenuBar()

		GlassPreferences.showConfigWindow()
		//glassView.showGlass()

		GlassPreferences.loadProfileSlots()

		NSApp.activate(ignoringOtherApps: true)
		
		// hide the dock icon (same as LSUIElement true in Info.plist)
		NSApp.setActivationPolicy(.accessory)
	}
}
