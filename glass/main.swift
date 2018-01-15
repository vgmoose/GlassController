//
//  Main.swift
//  glass
//
//  Created by Ricky Ayoub on 1/15/18.
//

import Foundation
import AppKit
import Cocoa

NSApplication.shared()
NSApp.setActivationPolicy(.regular)

let frameRect = NSMakeRect(0, 0, 800, 450)
let window = NSWindow(contentRect: frameRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
let view = GlassView(frame: window.frame)

view.isHidden = false
view.needsDisplay = true
window.contentView = view

window.cascadeTopLeft(from: NSMakePoint(20, 20))
window.title = "Touchpad Preview"
window.makeKeyAndOrderFront(nil)

// start touch listener for touchpad event
let dev = MTDeviceCreateDefault()
MTRegisterContactFrameCallback(dev, processTouchpadData);
MTDeviceStart(dev, 0);

NSApp.activate(ignoringOtherApps: true)
NSApp.run()
