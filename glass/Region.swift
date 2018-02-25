//
//  Region.swift
//  glass
//
//

import Foundation

/**
 A region defines an area of the trackpad that can be assigned to an input
 (either keyboard or gamepad)
 */
class Region
{
    // coordinates of the region (top left) (in percents)
    var x: Double, y: Double
    
    // size of this region (in percents)
    var width: Double, height: Double
    
    // the key to invoke
    var key: String = "s"
	var code: Int = 1
    
	init(_ keycode: Int, _ x: Double, _ y: Double, _ width: Double, _ height: Double)
    {
		self.key = "?"
		self.code = keycode
		
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    func getValue(_ col: String) -> String
    {
        // given a string identifier (from the table col) return the appropriate property
        if col == "X" { return String(self.x) }
        if col == "Y" { return String(self.y) }
        if col == "Width" { return String(self.width) }
        if col == "Height" { return String(self.height) }
        return self.key
    }
}
