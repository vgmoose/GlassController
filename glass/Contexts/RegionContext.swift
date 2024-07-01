//
//  RegionContext.swift
//  GlassController
//
//  Created by User on 6/30/24.
//

import Foundation
import AppKit

// A version fo "Region" that applies implicitly
// TODO: Consolidate, either via hybrid Region/Contexts, or chainable versions
// like And or Or, right now this is copypasta'd and modified from Region.swift

class RegionContext : Context {
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
    
    override func serialize() -> [String: Any]?
    {
        return [
            "type": "Region",
            "x": x,
            "y": y,
            "width": width,
            "height": height
        ]
    }
    
    override func valid(_ cx: Double = 0, _ cy: Double = 0) -> Bool {
        return intersects(cx, cy, x, y - height, x + width, y)
    }
    
    // detect if a circle is intersecting with a rectangle
    func intersects(_ cx: Double, _ cy: Double, _ left: Double, _ top: Double, _ right: Double, _ bottom: Double) -> Bool
    {
        return cx >= left && cx <= right && cy >= top && cy <= bottom
    }
}
