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
    let configRect = NSMakeRect(0, 0, 300, 200)
    let window = NSWindow(contentRect: configRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
    
    let inner = NSView(frame: configRect)
    inner.isHidden = false
    inner.needsDisplay = true
    window.contentView = inner
    
    let button = NSButton()
    button.setButtonType(.momentaryLight)
    button.bezelStyle = .rounded
    button.target = view
    button.action = Selector("showGlass")
    button.frame = NSMakeRect(0, 0, 250, 20)
    button.title = "Show Touchpad Preview"
    
    inner.addSubview(button)
    
    window.cascadeTopLeft(from: NSMakePoint(20, 20))
    window.title = "GlassCon Preferences"
    window.makeKeyAndOrderFront(nil)
}

// start touch listener for touchpad event
let dev = MTDeviceCreateDefault()
MTRegisterContactFrameCallback(dev, processTouchpadData);
MTDeviceStart(dev, 0);

showConfigWindow()

NSApp.activate(ignoringOtherApps: true)
NSApp.run()
