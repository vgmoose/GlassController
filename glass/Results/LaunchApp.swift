//
//  LaunchApp.swift
//  GlassCon
//
//

import Foundation
import AppKit

class LaunchApp : Result
{
    init(_ path: String)
    {
        super.init()
        
        super.key = path
        super.hashValue = path.hashValue
    }
    
    override func toString() -> String {
        return "\(self.key.split(separator: "/").last ?? "?")"
    }
    
    override func invoke(_ enabled: Bool)
    {
		NSWorkspace.shared.launchApplication(key);
    }
	
	override func serialize() -> [String: Any]?
	{
		return [
			"type": "LaunchApp",
			"path": key,
		]
	}
}
