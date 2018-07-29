//
//  Action.swift
//  GlassCon
//
//

import Foundation

// Action is a pairing of KeyBinding and Activator

class Action
{
    let keyBinding: KeyBinding
    let activator: Activator
    
    init(_ keyBinding: KeyBinding, _ activator: Activator)
    {        
        self.keyBinding = keyBinding
        self.activator = activator
    }
    
    func getValue(_ value: String) -> String
    {
        // given a string identifier (from the table col) return the appropriate property
        if (value == "Key Binding") { return self.keyBinding.toString() }
        if (value == "Action") { return self.activator.toString() }
        return "?"
    }
}
