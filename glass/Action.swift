//
//  Action.swift
//  GlassCon
//
//

import Foundation
import AppKit

// Action is a pairing of KeyBinding and Activator

class Action
{
    var result: Result
    var activator: Activator
	var context: Context
    
    var lastFrame: Int32 = -1
	
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
        if (value == "Activator") { return self.activator.toString() }
        if (value == "Context") { return self.context.toString() }
        return "?"
    }
	
	func serialize() -> [String: [String: Any]?]
	{
		return [
			"result": self.result.serialize(),
			"activator": self.activator.serialize(),
			"context": self.context.serialize()
		]
	}
}
