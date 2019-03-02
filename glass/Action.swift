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
	let context: Context
	
	convenience init(_ result: Result, _ activator: Activator)
	{
		self.init(result, activator, Context("*"))
	}
	
	// takes the end result to be invoked, and the activator that activates it
	init(_ result: Result, _ activator: Activator, _ context: Context)
    {        
        self.result = result
        self.activator = activator
		self.context = context
    }
    
    func getValue(_ value: String) -> String
    {
        // given a string identifier (from the table col) return the appropriate property
        if (value == "Result") { return self.result.toString() }
        if (value == "Action") { return self.activator.toString() }
        if (value == "Context") { return self.context.toString() }
        return "?"
    }
}
