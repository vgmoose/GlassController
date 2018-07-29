//
//  KeyBinding.swift
//  GlassCon
//
//

import Foundation

class KeyBinding
{
    var key: String
    var code: Int
    
    var opts: [String]
    
    init(_ code: Int, _ opts: [String] = [])
    {
        self.code = code
        self.opts = opts
        
        self.key = KeyBinding.calculateForCode(code)
    }
    
    static func calculateForCode(_ code: Int) -> String
    {
        if (code == kVK_LeftArrow) { return "←" }
        if (code == kVK_RightArrow) { return "→" }
        if (code == kVK_UpArrow) { return "↓" }
        if (code == kVK_DownArrow) { return "↑" }
        
        return String(keyCodeToString(CGKeyCode(code)))
    }
    
    func toString() -> String
    {
        // TODO: show any opts (held keys) as well
        return self.key
    }
}
