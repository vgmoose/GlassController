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
    }
	
	override func hash(into hasher: inout Hasher) {
		hasher.combine(self.key)
	}
    
    override func toString() -> String {
        return "\(self.key.split(separator: "/").last ?? "?")"
    }
    
    override func invoke(_ enabled: Bool)
    {
        // https://stackoverflow.com/a/58241536
        let url = NSURL(fileURLWithPath: key, isDirectory: true) as URL

        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
//		NSWorkspace.shared.launchApplication(key);
    }
	
	override func serialize() -> [String: Any]?
	{
		return [
			"type": "LaunchApp",
			"path": key,
		]
	}
}
