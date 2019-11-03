//
//  MouseClick.swift
//  GlassCon
//
//

import Foundation

class MouseClick : Result
{
	var button: CGMouseButton
	
	init(_ button: CGMouseButton, _ opts: [Int] = [])
	{
		self.button = button

		super.init()
		super.opts = opts
		super.code = Int(button.rawValue)
		
		super.key = MouseClick.calculateForCode(code)
		super.hashValue = self.code * self.opts.reduce(0, { $0 + $1 })
	}
	
	static func calculateForCode(_ code: Int) -> String
	{
		if (code == CGMouseButton.left.rawValue) { return "Click" }
		if (code == CGMouseButton.right.rawValue) { return "RightClick" }
		if (code == CGMouseButton.center.rawValue) { return "MiddleClick" }
		
		if (code == kVK_Control) { return "⌃" }
		if (code == kVK_Command) { return "⌘" }
		if (code == kVK_Shift) { return "⇧" }
		if (code == kVK_Option) { return "⌥" }
		if (code == kVK_CapsLock) { return "⇪" }
		if (code == kVK_Function) { return "Fn" }
		
		return String(keyCodeToString(CGKeyCode(code)) ?? "?").uppercased()
	}
	
	override func toString() -> String
	{
		let held = self.opts.map { KeyBinding.calculateForCode($0) }.reduce("", { "\($0)\($1)" })
		
		return "\(held)\(self.key)"
	}
	
	func resolveModifier(_ opt: Int) -> CGEventFlags
	{
		if kVK_Command == opt { return CGEventFlags.maskCommand }
		if kVK_Control == opt { return CGEventFlags.maskControl }
		if kVK_Option == opt { return CGEventFlags.maskAlternate }
		if kVK_Shift == opt { return CGEventFlags.maskShift }
		
		return CGEventFlags(rawValue: 0)
	}
	
	override func invoke(_ enabled: Bool)
	{
		if (!enabled) {
			// we fire all at once here, don't care when teh gesture ends
			return
		}
		let cur = CGEvent(source: nil);
		let point = cur!.location;
		
		let eventDown = CGEvent(mouseEventSource: nil, mouseType: .otherMouseDown, mouseCursorPosition: point, mouseButton: button)
		let eventUp = CGEvent(mouseEventSource: nil, mouseType: .otherMouseUp, mouseCursorPosition: point, mouseButton: button)

		
		var modifiers: CGEventFlags = CGEventFlags(rawValue: 0)
		
		for opt in self.opts
		{
			modifiers.insert(self.resolveModifier(opt))
		}
		
		eventDown!.flags = modifiers
		eventDown!.post(tap: .cghidEventTap)
		
		eventUp!.flags = modifiers
		eventUp!.post(tap: .cghidEventTap)
		
	}
	
	override func serialize() -> [String: Any]?
	{
		return [
			"type": "MouseClick",
			"button": code,
			"modifiers": opts
		]
	}
}
