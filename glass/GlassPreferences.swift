//
//  GlassPreferences.swift
//  GlassCon
//
//  Created by Ricky Ayoub on 2/16/18.
//

import Foundation
import AppKit

class GlassPreferences : NSWindow, NSTableViewDelegate, NSTableViewDataSource
{
    func createTableCol(_ tableView: NSTableView, _ text: String)
    {
        let col = NSTableColumn(identifier: text)
        tableView.addTableColumn(col)
        col.headerCell.stringValue = text
    }
    
    init()
    {
        let WIDTH = CGFloat(550)
        let HEIGHT = CGFloat(350)
        
        glassView.regions.append(Region(125, 0, 0.25, 1, 0.25))	// up
		glassView.regions.append(Region(123, 0, 1, 0.25, 1))		// left
		glassView.regions.append(Region(126, 0, 1, 1, 0.25))		// down
		glassView.regions.append(Region(124, 0.75, 1, 0.25, 1))	// right

        
        let configRect = NSMakeRect(0, 0, WIDTH, HEIGHT)
        super.init(contentRect: configRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        
        let window = self
        
        let inner = NSView(frame: configRect)
        inner.isHidden = false
        inner.needsDisplay = true
        window.contentView = inner
        
        // preview button
        let button = NSButton()
        button.setButtonType(.momentaryLight)
        button.bezelStyle = .rounded
        button.target = glassView
        button.action = #selector(GlassView.showGlass)
        button.frame = NSMakeRect(0, 0, 250, 20)
        button.title = "Show Touchpad Preview"
        inner.addSubview(button)
        
        // checkbox to totally enable/disable action listeners
        let checkbox = NSButton()
        checkbox.setButtonType(NSSwitchButton)
        checkbox.title = "Activate Glass Controller"
        checkbox.frame = NSMakeRect(0, 0, 250, 20)
        checkbox.frame.origin = CGPoint(x: 0, y: 50)
        checkbox.state = getActivationState()
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
        createTableCol(tableView, "Mapped Key")
        createTableCol(tableView, "X")
        createTableCol(tableView, "Y")
        createTableCol(tableView, "Width")
        createTableCol(tableView, "Height")
        tableContainer.frame.origin = CGPoint(x: 0, y: 100)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        inner.addSubview(tableContainer)

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return glassView.regions.count;
    }
    
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any?
    {
        return glassView.regions[row].getValue((tableColumn?.identifier)!)
    }
    
    static func toggleGlass()
    {
        // toggle the state of the glass controller
        glassEnabled = !glassEnabled
        
        enabledMenuButton.state = getActivationState()
    }
    
    static func showConfigWindow()
    {
        let window = GlassPreferences()
        window.cascadeTopLeft(from: NSMakePoint(20, 20))
        window.title = "GlassCon Preferences"
        window.makeKeyAndOrderFront(nil)
    }
}
