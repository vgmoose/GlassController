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
    
    // detect if a circle is intersecting with a rectangle
    func intersects(_ cx: Double, _ cy: Double, _ left: Double, _ top: Double, _ right: Double, _ bottom: Double) -> Bool
    {
        return cx >= left && cx <= right && cy >= top && cy <= bottom
    }
}
