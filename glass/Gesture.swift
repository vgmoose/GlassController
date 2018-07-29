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
    
//    var activated_time: Date? = nil
    
    // the bounds for how long this gesture should last
    // nil == no bound in that direction (relative to activated_time)
//    var min_time: Date? = nil
//    var max_time: Date? = nil
    
    let minDistance = 0.15
    var matching = false
    
    var sxPos: Double = 0, syPos: Double = 0
    
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
    
    // returns true if it keeps going in the right direction
    // relative to the starting xpos, ypos
    func rightDirection(_ xpos: Double, _ ypos: Double) -> Double
    {
        if direction == Gesture.UP && ypos > self.syPos { return ypos - self.syPos }
        if direction == Gesture.DOWN && ypos < self.syPos { return self.syPos - ypos }
        if direction == Gesture.LEFT && xpos > self.sxPos { return xpos - self.sxPos }
        if direction == Gesture.RIGHT && xpos < self.sxPos { return self.sxPos - xpos }
        
        return -1
    }
    
    func matches(_ xpos: Double, _ ypos: Double, _ incoming: Int) -> Bool
    {
        if incoming == count
        {
            // if matching isn't true, set it and take note of the starting average
            if !matching
            {
                matching = true
                self.sxPos = xpos
                self.syPos = ypos
            }
            else
            {
                // already matching, if it goes over the bounds in the right direction, activate it
                let directionalComp = rightDirection(xpos, ypos)
                
                if directionalComp >= 0
                {
                    // if we meet the treshold
                    if directionalComp > minDistance
                    {
                        return true
                    }
                    
                    // otherwise, no problem, might match next time
                }
                else
                {
                    // broke going in the right direction, unmatch
                    matching = false
                }
            }
        }
        else
        {
            matching = false
        }
        
        return false
    }
}
