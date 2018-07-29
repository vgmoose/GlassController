//
//  Gesture.swift
//  GlassCon
//
//

import Foundation


class Gesture : Activator
{
    static var UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, TAP=4

    // the direction from the above values
    let direction: Int
    var humanDirection: String = "?"
    
    // the nunmber of fingers that this gesture requires to activate
    let count: Int
    
    var activated_time: Date? = nil
    
    // the bounds for how long this gesture should last
    // nil == no bound in that direction (relative to activated_time)
    var min_time: Date? = nil
    var max_time: Date? = nil
    
    init(_ direction: Int, _ count: Int)
    {
        self.direction = direction
        
        humanDirection = (direction == Gesture.UP) ? "Up" : humanDirection
        humanDirection = (direction == Gesture.DOWN) ? "Down" : humanDirection
        humanDirection = (direction == Gesture.LEFT) ? "Left" : humanDirection
        humanDirection = (direction == Gesture.RIGHT) ? "Right" : humanDirection
        
        self.count = count
        
        super.init()
    }
    
    override func toString() -> String
    {
        if (Gesture.TAP == direction) { return "Tap(fingers: \(count)" }
        
        return "Swipe(fingers: \(count), direction: \(humanDirection))"
    }
    
}
