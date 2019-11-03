//
//  File.swift
//  GlassCon
//
//

import Foundation
import AppKit

// A context contains passive information that should be checked before the activator is invoked
// to determine whether or not to fire that action's result
// the main difference between an Activator and a Context is an Activactor relies on some touchpad specific data
class Context
{
	var bundle: String
    
    init(_ bundle: String = "*")
    {
        self.bundle = bundle
    }
    
    func valid() -> Bool
    {
		// allow in any context
		if bundle == "*" {
			return true;
		}
		
		let curApp = NSWorkspace.shared().frontmostApplication?.bundleIdentifier ?? ""
		return curApp == bundle
    }
	
	func toString() -> String
	{
		if bundle == "*" {
			return "Any"
		}
		
		return bundle
	}
	
	func serialize() -> [String: Any]?
	{
		if bundle == "*" {
			return nil
		}
		
		return [
			"type": "AppBundle",
			"bundle": bundle
		]
	}
	
	static func deserialize(_ data: [String: AnyHashable]) -> Context
	{
		// check the type
		if let type = data["type"] as? String {
			if type == "AppBundle" {
				if let bundle = data["bundle"] as? String {
					return Context(bundle)
				}
			}
		}
		
		return Context()
	}
}
