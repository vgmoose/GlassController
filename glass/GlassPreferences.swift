//
//  GlassPreferences.swift
//  GlassCon
//
//

import Foundation
import AppKit

class GlassPreferences : NSWindow, NSTableViewDelegate, NSTableViewDataSource
{
	static var activeProfileSlot = UserDefaults.standard.integer(forKey: "activeProfile")
	static var slotNames = ["Profile 1", "Profile 2", "Profile 3"]
	
	var tableView: NSTableView
	
	static var me: GlassPreferences? = nil
	
    func createTableCol(_ tableView: NSTableView, _ text: String)
    {
		let col = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: text))
        tableView.addTableColumn(col)
        col.headerCell.stringValue = text
    }
    
    init()
    {
        let WIDTH = CGFloat(750)
        let HEIGHT = CGFloat(350)
        
        let configRect = NSMakeRect(0, 0, WIDTH, HEIGHT)
		self.tableView = NSTableView(frame:NSMakeRect(0, 0, WIDTH-16, HEIGHT-100))
        super.init(contentRect: configRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
		
		// load from the active slot!
		self.loadPrefs()
		glassView.syncActions()
		
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
		
		let export = NSButton()
		export.setButtonType(.momentaryLight)
		export.bezelStyle = .rounded
		export.target = self
		export.action = #selector(self.exportProfile)
		export.frame = NSMakeRect(0, 0, 75, 20)
		export.frame.origin = CGPoint(x: 5, y: 50)
		export.title = "Export"
		inner.addSubview(export)
		
		let importB = NSButton()
		importB.title = "Import"
		importB.bezelStyle = .rounded
		importB.setButtonType(.momentaryLight)
		importB.target = self
		importB.action = #selector(self.importProfile)
		importB.frame = NSMakeRect(0, 0, 75, 20)
		importB.frame.origin = CGPoint(x: 80, y: 50)
		inner.addSubview(importB)
        
        // the + and - buttons for actions
        let controls = NSSegmentedControl()
        controls.frame = NSMakeRect(0, 0, 100, 30)
        controls.frame.origin = CGPoint(x: 5, y: 70)
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
        createTableCol(tableView, "Result")
        createTableCol(tableView, "Activator")
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
		return glassView.actions[row].getValue((tableColumn?.identifier)!.rawValue)
    }
    
	@objc static func toggleGlass()
    {
        // toggle the state of the glass controller
        glassEnabled = !glassEnabled
        
        enabledMenuButton.state = getActivationState()
    }
    
	@objc    static func showConfigWindow()
    {
        let window = GlassPreferences()
        window.cascadeTopLeft(from: NSMakePoint(20, 20))
        window.title = "GlassCon Preferences"
        window.makeKeyAndOrderFront(nil)
		me = window
    }
	
	static func switchProfileCommon(_ slot: Int)
	{
		activeProfileSlot = slot
		loadProfileSlots()
		
		me!.loadPrefs()
		UserDefaults.standard.set(slot, forKey: "activeProfile")
	}
	
	// three slots to manage profiles i@objc n
	@objc static func switchProfile1() { GlassPreferences.switchProfileCommon(0) }
	@objc static func switchProfile2() { GlassPreferences.switchProfileCommon(1) }
	@objc static func switchProfile3() { GlassPreferences.switchProfileCommon(2) }
    
    @objc static func restartListeners()
    {
        Process.launchedProcess(launchPath: Bundle.main.executablePath!, arguments: [])
        NSApp.terminate(self)
    }
	
	static func loadProfileSlots() {
		
		for x in 0..<3 {
			profileItems[x].state = NSControl.StateValue(rawValue: activeProfileSlot == x ? 1 : 0)
			profileItems[x].title = UserDefaults.standard.string(forKey: "prefs\(x)_name") ?? "Profile \(x+1)"
			slotNames[x] = profileItems[x].title
		}
	}
	
	func setNameForActiveSlot(_ name: String) {
		let x = GlassPreferences.activeProfileSlot
		GlassPreferences.slotNames[x] = name
		UserDefaults.standard.set(name, forKey: "prefs\(x)_name")
		GlassPreferences.loadProfileSlots()
	}

	// from a json string, update our actions
	func applyPrefs(_ prefString: String)
	{
		let data = Data(prefString.utf8)
		do {
			let myJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
			
			setNameForActiveSlot(myJson["name"] as? String ?? "Custom Profile")
			
			if let actions = myJson["actions"] as? Array<[AnyHashable:AnyHashable]> {
				glassView.actions = []
				
				for cur:[AnyHashable:AnyHashable] in actions {
					if let curAction = cur as? [String:AnyHashable] {
						let newAction = Action(Result(), Activator())
						
						if let activator = curAction["activator"] as? [String:AnyHashable] {
							newAction.activator = Activator.deserialize(activator)
						}
						if let result = curAction["result"] as? [String:AnyHashable] {
							newAction.result = Result.deserialize(result)
						}
						if let context = curAction["context"] as? [String:AnyHashable] {
							newAction.context = Context.deserialize(context)
						}
						glassView.actions.append(newAction)
					}
				}
				
				glassView.syncActions()
				self.tableView.reloadData()
			}
		} catch let error {
			Swift.print(error)
		}
	}
	
	func savePrefs()
	{
		let title = profileItems[GlassPreferences.activeProfileSlot].title
		UserDefaults.standard.set(glassView.toJSON(title), forKey: "prefs\(GlassPreferences.activeProfileSlot)_data")
	}
	
	@objc func loadPrefs()
	{
		let defaultPrefs = "{\"actions\": []}"

		let res = UserDefaults.standard.string(forKey: "prefs\(GlassPreferences.activeProfileSlot)_data")
		
		applyPrefs(res ?? defaultPrefs)
	}
	
	@objc func exportProfile()
	{
		let out = glassView.toJSON(profileItems[GlassPreferences.activeProfileSlot].title)

		let openPanel = NSSavePanel();
		openPanel.title = "Export profile data"
		openPanel.isExtensionHidden = false
		
		var dateString: String {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			
			return formatter.string(from: Date())
		}
		
		openPanel.showsResizeIndicator = true
		openPanel.allowedFileTypes = ["json"]
		openPanel.nameFieldStringValue = "GlassConPrefs_\(dateString)"
		
		openPanel.begin { (result) -> Void in
			if(result.rawValue == NSFileHandlingPanelOKButton){
				let path = openPanel.url!
				do {
					try out.write(to: path, atomically: false, encoding: .utf8)
				} catch {
					Swift.print("Some error while writing f@objc ile")
				}
			}
		}
	}
	
	@objc func importProfile()
	{
		let openPanel = NSOpenPanel();
		openPanel.title = "Import profile data"
		openPanel.showsResizeIndicator = true;
		
		openPanel.begin { (result) -> Void in
			if(result.rawValue == NSFileHandlingPanelOKButton){
				let path = openPanel.url!.path
				do {
					try self.applyPrefs(String(contentsOfFile: path))
					self.savePrefs()	// imports over the current active slot
				} catch {
					Swift.print("Couldn't apply profile..")
				}
			}
		}
	}
}
