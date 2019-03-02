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
    var bundle = "?";
    
    init(_ bundle: String)
    {
        self.bundle = bundle
    }
    
    func valid() -> Bool
    {
		// allow in any context
		if bundle == "*" {
			return true;
		}
		
		var curApp = NSWorkspace.shared().frontmostApplication?.bundleIdentifier ?? ""
		print(curApp)
		return curApp == bundle
    }
	
	func toString() -> String
	{
		if bundle == "*" {
			return "Any"
		}
		
		return bundle
	}
}
