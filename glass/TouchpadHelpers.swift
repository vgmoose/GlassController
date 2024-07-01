import Foundation

public func printTouchInfo(_ finger: Finger)
{
//    print("Frame \(finger.frame): Angle \(finger.angle * 90 / atan2(1,0)), ellipse \(finger.majorAxis) \(finger.minorAxis); position (\(finger.normalized.pos.x),\(finger.normalized.pos.y) vel (\(finger.normalized.vel.x),\(finger.normalized.vel.y); ID \(finger.identifier), state \(finger.state) [\(finger.foo3) \(finger.foo4)?] size \(finger.size), \(finger.unk2)?\n")
}

// MTDeviceRef device, MTTouch touches[], size_t numTouches, double timestamp, size_t frame
public func processTouchpadData(_ device: Optional<AnyObject>, _ data: Optional<UnsafeMutablePointer<Finger>>, _ nFingers: Int, _ timestamp: Double, _ frame: Int) -> ()
{

    let fingers = Array(UnsafeBufferPointer(start: data, count: Int(nFingers)))
	
	let view = GlassDelegate.glassView!
	let glassView = view
    
    view.fingers = fingers
    view.refresh()
    
    // newly pressed value
    var pressed:Set<Result> = Set()
    
    var xAvg: Double = 0
    var yAvg: Double = 0
    
    var fireAmounts = [
        Gesture.UP: 0,
        Gesture.DOWN: 0,
        Gesture.LEFT: 0,
        Gesture.RIGHT: 0,
        Gesture.TAP: 0
    ]
    
    let minDist: Float = 1.0
    var tossItAllOut = false

    // if it's the first region, send an S
    for finger in fingers
    {
        let vec = finger.normalizedVector
        printTouchInfo(finger)

		let xpos = Double(vec.position.x)
		let ypos = Double(vec.position.y)
        
        for action in glassView.regions
        {
            let region = action.activator as! Region
            
            if region.intersects(xpos, ypos, region.x, region.y - region.height, region.x + region.width, region.y)
            && action.context.valid()
            {
                action.lastFrame = finger.frame
                pressed.insert(action.result)
            }
        }
        
        // if this finger has a velocity amount over a treshold, increase its fire count
        if vec.velocity.y > minDist {
            fireAmounts[Gesture.UP]! += 1
        } else if vec.velocity.y < -minDist {
            fireAmounts[Gesture.DOWN]! += 1
        } else if vec.velocity.x > minDist {
            fireAmounts[Gesture.RIGHT]! += 1
        } else if vec.velocity.x < -minDist {
            fireAmounts[Gesture.LEFT]! += 1
        // if it didn't move much
        } else if abs(vec.velocity.x) < 0.1 && abs(vec.velocity.y) < 0.1 {
            fireAmounts[Gesture.TAP]! += 1
        } else {
            // moving, but not enough to count, and not enough to be still.. so toss it all out
            tossItAllOut = true
        }
        
        xAvg += xpos
        yAvg += ypos

    }
    
    xAvg /= Double(fingers.count)
    yAvg /= Double(fingers.count)
    
    // only run our gesture logic if we know we have sum(each value in fireAmounts) == fingers.count
    if !tossItAllOut {
        for action in glassView.gestures {
            
            // only run this gesture if at least count fingers meat the context
            // TODO: clean up this kind of combo check (see top of RegionControl)
            var validContexts = 0
            for finger in fingers {
                let vec = finger.normalizedVector
                let xpos = Double(vec.position.x)
                let ypos = Double(vec.position.y)
                
                if action.context.valid(xpos, ypos) {
                    validContexts += 1
                }
            }
            
            // see if we match any of the criterias
            let gesture = action.activator as! Gesture
            
            if gesture.direction == Gesture.TAP && validContexts > 0 { // tap only needs 1 finger to match
                // taps use old matching logic
                if gesture.matches(xAvg, yAvg, fingers.count) {
                    pressed.insert(action.result)
                    gesture.fire()
                }
            }
            else if gesture.count == fireAmounts[gesture.direction] && gesture.canFire() && validContexts >= gesture.count {
                // we got a matching amount of activations for this count
                pressed.insert(action.result)
                gesture.fire()
            }
        }
    }
    
//    if fingers.count != 0 {
//
////        let speeds = fingers.map { $0.normalizedVector.velocity }
//
//        // try to detect any gestures using the average of all the points
//        for action in glassView.gestures
//        {
//            let gesture = action.activator as! Gesture
//
//            // if the current conditions match the gesture
//            if gesture.matches(speeds, fingers.count) && action.context.valid()
//            {
//                action.lastFrame = fingers[0].frame
//                pressed.insert(action.result)
//            }
//        }
//    }
    
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
}
