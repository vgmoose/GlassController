//
//  KeyBinding.swift
//  GlassCon
//
//

import Foundation

class KeyBinding : Result
{
    init(_ code: Int, _ opts: [Int] = [])
    {
        super.init()
        super.code = code
        super.opts = opts
        
        super.key = KeyBinding.calculateForCode(code)
        super.hashValue = self.code * self.opts.reduce(0, { $0 + $1 })
    }
    
    static func calculateForCode(_ code: Int) -> String
    {
        if (code == kVK_LeftArrow) { return "←" }
        if (code == kVK_RightArrow) { return "→" }
        if (code == kVK_DownArrow) { return "↓" }
        if (code == kVK_UpArrow) { return "↑" }
        
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
        if context?.valid() ?? false {
            return
        }
        
        let inputKeyCode = CGKeyCode(self.code)
        let event = CGEvent(keyboardEventSource: nil, virtualKey: inputKeyCode, keyDown: enabled)
        var modifiers: CGEventFlags = CGEventFlags(rawValue: 0)
        
        for opt in self.opts
        {
            modifiers.insert(self.resolveModifier(opt))
        }
        
        event!.flags = modifiers
        event!.post(tap: .cghidEventTap)
        
    }
}
