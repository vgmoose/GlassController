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
class Region : Activator
{
    // coordinates of the region (top left) (in percents)
    var x: Double, y: Double
    
    // size of this region (in percents)
    var width: Double, height: Double
    
	init(_ x: Double, _ y: Double, _ width: Double, _ height: Double)
    {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    override func toString() -> String
    {
        return "Region(x: \(x), y: \(y), width: \(width), height: \(height))"
    }
}
