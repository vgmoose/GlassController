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
    
    override func invoke(_ enabled: Bool)
    {
        NSWorkspace.shared().launchApplication(key);
    }
}
