//
//  Action.swift
//  GlassCon
//
//

import Foundation

// Action is a pairing of KeyBinding and Activator

class Action
{
    let result: Result
    let activator: Activator
    
    init(_ result: Result, _ activator: Activator)
    {        
        self.result = result
        self.activator = activator
    }
    
    func getValue(_ value: String) -> String
    {
        // given a string identifier (from the table col) return the appropriate property
        if (value == "Result") { return self.result.toString() }
        if (value == "Action") { return self.activator.toString() }
        if (value == "Context") { return self.result.context?.bundle ?? "Any" }
        return "?"
    }
}
