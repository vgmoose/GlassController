//
//  GlassPreferences.swift
//  GlassCon
//
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
        let WIDTH = CGFloat(750)
        let HEIGHT = CGFloat(350)
        
//        var region = Region(0, 1, 1, 0.25)
		var binding: Result = KeyBinding(kVK_UpArrow)
//        glassView.actions.append(Action(binding, region))    // up
//
//        region = Region(0, 1, 0.25, 1)
//        binding = KeyBinding(kVK_LeftArrow)
//        glassView.actions.append(Action(binding, region))        // left
//
//        region = Region(0, 0.25, 1, 0.25)
//        binding = KeyBinding(kVK_DownArrow)
//        glassView.actions.append(Action(binding, region))        // down
//
//        region = Region(0.75, 1, 0.25, 1)
//        binding = KeyBinding(kVK_RightArrow)
//        glassView.actions.append(Action(binding
//            , region))    // right
		
        // mission control on four fingers down
        var gesture = Gesture(Gesture.DOWN, 4)
        binding = KeyBinding(kVK_ANSI_M, [kVK_Control, kVK_Command, kVK_Option])
        glassView.actions.append(Action(binding, gesture))

        gesture = Gesture(Gesture.UP, 4)
        binding = KeyBinding(kVK_ANSI_A, [kVK_Control, kVK_Command, kVK_Option])
        glassView.actions.append(Action(binding, gesture))

        gesture = Gesture(Gesture.DOWN, 5)
        binding = KeyBinding(kVK_ANSI_W, [kVK_Command])
        glassView.actions.append(Action(binding, gesture))

        gesture = Gesture(Gesture.UP, 5)
        binding = LaunchApp("/Applications/Utilities/Terminal.app");
        glassView.actions.append(Action(binding, gesture))

        gesture = Gesture(Gesture.LEFT, 2)
        binding = KeyBinding(kVK_UpArrow)
        var context = Context("com.apple.Terminal")
        glassView.actions.append(Action(binding, gesture, context))

        gesture = Gesture(Gesture.RIGHT, 2)
        binding = KeyBinding(kVK_DownArrow)
        context = Context("com.apple.Terminal")
        glassView.actions.append(Action(binding, gesture, context))

        glassView.syncActions()
        
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
        
        // the + and - buttons for actions
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
        createTableCol(tableView, "Result")
        createTableCol(tableView, "Action")
        createTableCol(tableView, "Context")
        tableContainer.frame.origin = CGPoint(x: 0, y: 100)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        
        tableView.tableColumns[1].width = 400
        tableView.tableColumns[2].width = 150
        
        inner.addSubview(tableContainer)

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return glassView.actions.count;
    }
    
    func tableView(_ tableView: NSTableView,
                   objectValueFor tableColumn: NSTableColumn?,
                   row: Int) -> Any?
    {
        return glassView.actions[row].getValue((tableColumn?.identifier)!)
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
