//
//  Gesture.swift
//  GlassCon
//
//

import Foundation


class Gesture : Activator
{
    static var UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, TAP = 4

    // the direction from the above values
    let direction: Int
    var humanDirection: String = "?"
    
    // the nunmber of fingers that this gesture requires to activate
    let count: Int
	
	var cur_time = NSDate()
    
    // the bounds for how long this gesture should last
    // nil == no bound in that direction (relative to activated_time)
//    var min_time: Date? = nil
    var max_time: Date? = nil
	
    let minDistance = 0.15
    var matching = false
	
	var lastXPos: Double = 0, lastYPos: Double = 0
    
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
        if (Gesture.TAP == direction) { return "Tap(fingers: \(count))" }
        
        return "Swipe(fingers: \(count), direction: \(humanDirection))"
    }
	
	override func serialize() -> [String: Any]?
	{
		if (direction == Gesture.TAP) {
			return [
				"type": "Tap",
				"fingers": count
			]
		}
		return [
			"type": "Swipe",
			"fingers": count,
			"direction": direction
		]
	}
    
    // returns true if it keeps going in the right direction
    // relative to the starting xpos, ypos
    func rightDirection(_ xpos: Double, _ ypos: Double) -> Double
    {
        if direction == Gesture.TAP { return abs((self.syPos + self.sxPos) - (ypos + xpos)) }
        if direction == Gesture.UP && ypos > self.syPos { return ypos - self.syPos }
        if direction == Gesture.DOWN && ypos < self.syPos { return self.syPos - ypos }
        if direction == Gesture.RIGHT && xpos > self.sxPos { return xpos - self.sxPos }
        if direction == Gesture.LEFT && xpos < self.sxPos { return self.sxPos - xpos }
        
        return -1
    }
    
    func matches(_ xpos: Double, _ ypos: Double, _ incoming: Int) -> Bool
    {
		if incoming == 0 {
			if (Gesture.TAP == direction) {
				// if we've been up within ~half a second of the last time we went up...
				// and also haven't moved much... (half of regular treshold)
				if cur_time.timeIntervalSinceNow > -0.45 && rightDirection(lastXPos, lastYPos) < minDistance / 2
				{
					return true
				}
			}
		}
        if incoming == count
        {
            // if matching isn't true, set it and take note of the starting average
            if !matching
            {
                matching = true
                self.sxPos = xpos
                self.syPos = ypos
				
				cur_time = NSDate()
            }
            else
            {
				if (Gesture.TAP == direction)
				{
					// as long as not too long has passed since touchdown
					self.lastXPos = xpos
					self.lastYPos = ypos
					return false
				}

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
