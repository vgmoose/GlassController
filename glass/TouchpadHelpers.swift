import Foundation

public func printTouchInfo(_ finger: Finger)
{
    print("Frame \(finger.frame): Angle \(finger.angle * 90 / atan2(1,0)), ellipse \(finger.majorAxis) \(finger.minorAxis); position (\(finger.normalized.pos.x),\(finger.normalized.pos.y) vel (\(finger.normalized.vel.x),\(finger.normalized.vel.y); ID \(finger.identifier), state \(finger.state) [\(finger.foo3) \(finger.foo4)?] size \(finger.size), \(finger.unk2)?\n")
}

public func processTouchpadData(_ device: Int32, _ data: Optional<UnsafeMutablePointer<Finger>>, _ nFingers: Int32, _ timestamp: Double, _ frame: Int32) -> Int32
{

    let fingers = Array(UnsafeBufferPointer(start: data, count: Int(nFingers)))
    
    view.fingers = fingers
    view.refresh()
    
    // newly pressed value
    var pressed:Set<Result> = Set()
    
    var xAvg: Double = 0
    var yAvg: Double = 0
    
    // if it's the first region, send an S
    for finger in fingers
    {
        printTouchInfo(finger)

        let xpos = Double(finger.normalized.pos.x)
        let ypos = Double(finger.normalized.pos.y)
        
        for action in glassView.regions
        {
            let region = action.activator as! Region
            
            if region.intersects(xpos, ypos, region.x, region.y - region.height, region.x + region.width, region.y)
            && action.context.valid()
            {
                 pressed.insert(action.result)
            }
        }

        xAvg += xpos
        yAvg += ypos
    }
    
    xAvg /= Double(fingers.count)
    yAvg /= Double(fingers.count)
    
    // try to detect any gestures using the average of all the points
    for action in glassView.gestures
    {
        let gesture = action.activator as! Gesture
        
        // if the current conditions match the gesture
        if gesture.matches(xAvg, yAvg, fingers.count) && action.context.valid()
        {
            pressed.insert(action.result)
        }
    }
    
    // clone the newly pressed array to prepare for the subtractions below
    let pressedClone = Set(pressed)
    
    // remove the overlap of old pressed from the new, to get just the new
    pressed.subtract(view.pressed)
    let newlyPressed = pressed
    
    // remove the overlap of new pressed from the old, to get just the old
    view.pressed.subtract(pressedClone)
    let newlyReleased = view.pressed
    
    // press down any new keys that we saw
    for key in newlyPressed {
        view.sendKey(key, true)
    }
    
    // release any old keys that we didn't see
    for key in newlyReleased {
        view.sendKey(key, false)
    }
    
    // update which keys are down right nowsss
    view.pressed = pressedClone
    
    return 0;
}
