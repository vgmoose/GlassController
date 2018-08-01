//
//  File.swift
//  GlassCon
//
//  Created by Ricky Ayoub on 8/1/18.
//

import Foundation
import AppKit

class Context
{
    var bundle = "?";
    
    init(_ bundle: String)
    {
        self.bundle = bundle
    }
    
    func valid() -> Bool
    {
        return NSWorkspace.shared().frontmostApplication!.bundleIdentifier! == bundle
    }
}
