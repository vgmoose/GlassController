//
//  Result.swift
//  GlassCon
//
//

import Foundation

class Result : Hashable
{
	func hash(into hasher: inout Hasher) {
		// override in subclass
	}

    static func ==(lhs: Result, rhs: Result) -> Bool {
        return lhs.code == rhs.code && lhs.opts == rhs.opts && lhs.key == rhs.key
    }
    
    var key: String = ""
    var code: Int = 0
    
    var opts: [Int] = []
        
    func invoke(_ enabled: Bool)
    {
        // do nothing (override me)
    }
    
    func toString() -> String
    {
        return "?"
    }
	
	func serialize() -> [String: Any]?
	{
		return nil
	}
	
	static func deserialize(_ data: [String: AnyHashable]) -> Result
	{
		// check the type
		if let type = data["type"] as? String {
			if type == "KeyBinding" {
				if let keycode = data["keycode"] as? Int, let modifiers = data["modifiers"] as? [Int] {
					return KeyBinding(keycode, modifiers)
				}
			} else if type == "LaunchApp" {
				if let path = data["path"] as? String {
					return LaunchApp(path)
				}
			} else if type == "MouseClick" {
				if let button = data["button"] as? Int, let modifiers = data["modifiers"] as? [Int] {
					return MouseClick(CGMouseButton(rawValue: UInt32(button))!, modifiers)
				}
			}
		}
		
		return Result()
	}
}

