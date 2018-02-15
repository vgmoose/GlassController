import Foundation
import AppKit
import Cocoa

NSApplication.shared()
NSApp.setActivationPolicy(.regular)

var previewWindow: NSWindow?
let frameRect = NSMakeRect(0, 0, 800, 450)
let view = GlassView(frame: frameRect)

func showPreviewWindow()
{
    // window already being displayed, return
    if previewWindow != nil { previewWindow = nil }
    
    let window = NSWindow(contentRect: frameRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    previewWindow = window;

    view.isHidden = false
    view.needsDisplay = true
    window.contentView = view
    
    window.cascadeTopLeft(from: NSMakePoint(20, 20))
    window.title = "Touchpad Preview"
    window.makeKeyAndOrderFront(nil)

}

func showConfigWindow()
{
    let WIDTH = CGFloat(400)
    let HEIGHT = CGFloat(350)
    
    let configRect = NSMakeRect(0, 0, WIDTH, HEIGHT)
    let window = NSWindow(contentRect: configRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    
    let inner = NSView(frame: configRect)
    inner.isHidden = false
    inner.needsDisplay = true
    window.contentView = inner
    
    // preview button
    let button = NSButton()
    button.setButtonType(.momentaryLight)
    button.bezelStyle = .rounded
    button.target = view
    button.action = Selector("showGlass")
    button.frame = NSMakeRect(0, 0, 250, 20)
    button.title = "Show Touchpad Preview"
    inner.addSubview(button)

    // checkbox to totally enable/disable action listeners
    let checkbox = NSButton()
    checkbox.setButtonType(NSSwitchButton)
    checkbox.title = "Activate Glass Controller"
    checkbox.frame = NSMakeRect(0, 0, 250, 20)
    checkbox.frame.origin = CGPoint(x: 0, y: 50)
    inner.addSubview(checkbox)
    
    // the + and - buttons for regions
    let controls = NSSegmentedControl()
    controls.frame = NSMakeRect(0, 0, 100, 20)
    controls.frame.origin = CGPoint(x: 0, y: 80)
    controls.segmentCount = 2
    controls.setLabel("+", forSegment: 0)
    controls.setLabel("-", forSegment: 1)
    controls.segmentStyle = .smallSquare
    if #available(OSX 10.10.3, *) {
        controls.trackingMode = .momentary
    }
    inner.addSubview(controls)
    
    // the current regions on the touchpad and action mappings
    let tableContainer = NSScrollView(frame:NSMakeRect(0, 0, WIDTH, HEIGHT-100))
    let tableView = NSTableView(frame:NSMakeRect(0, 0, WIDTH-16, HEIGHT-100))
    tableView.addTableColumn(NSTableColumn(identifier: "Action"))
    tableView.addTableColumn(NSTableColumn(identifier: "X"))
    tableView.addTableColumn(NSTableColumn(identifier: "Y"))
    tableView.addTableColumn(NSTableColumn(identifier: "width"))
    tableView.addTableColumn(NSTableColumn(identifier: "height"))
    tableContainer.frame.origin = CGPoint(x: 0, y: 100)
//    tableView.setDelegate(self)
//    tableView.setDataSource(self)
    tableView.reloadData()
    tableContainer.documentView = tableView
    tableContainer.hasVerticalScroller = true
    inner.addSubview(tableContainer)
    
    window.cascadeTopLeft(from: NSMakePoint(20, 20))
    window.title = "GlassCon Preferences"
    window.makeKeyAndOrderFront(nil)
}

// start touch listener for touchpad event
let dev = MTDeviceCreateDefault()
MTRegisterContactFrameCallback(dev, processTouchpadData);
MTDeviceStart(dev, 0);

// show the preferences window
showConfigWindow()

NSApp.activate(ignoringOtherApps: true)
NSApp.run()
