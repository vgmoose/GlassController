import Foundation
import AppKit

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

class GlassView : NSView
{
    var fingers: [Finger] = []
    var actions: [Action] = []
    
    var gestures: [Action] = []
    var regions: [Action] = []
    
    var pressed:Set<Result> = Set()
    
//    var activated = false
    
    func refresh()
    {
        // TODO: don't go in here at all unless the display is up
        DispatchQueue.main.sync {
            self.needsDisplay = true
        }
    }
    
    func syncActions()
    {
        // fill gestures and regions from actions
        gestures = actions.filter { $0.activator is Gesture }
        regions = actions.filter { $0.activator is Region }
    }
    
    func showGlass()
    {
        showPreviewWindow()
    }

    func sendKey(_ result: Result, _ enabled: Bool)
    {
        if !glassEnabled { return }
        
        // invoke this keybinding, as well as whatever modifiers it has
        result.invoke(enabled)
    }
    
    override func draw(_ rect: NSRect)
    {
        for finger in fingers
        {
            var center = CGPoint()
            let bounds = self.bounds
            
            let radius = CGSize(width: CGFloat(finger.size)*20, height: CGFloat(finger.size)*20)

            center.x = CGFloat(finger.normalized.pos.x * Float(bounds.width)) - CGFloat(radius.width/2)
            center.y = CGFloat(finger.normalized.pos.y * Float(bounds.height)) - CGFloat(radius.height/2)

            let path = NSBezierPath(ovalIn: CGRect(origin: center, size: radius))
            NSColor.gray.setFill()
            path.fill()
        }
        
        for action in regions
        {
            let region = action.activator as! Region
			
            var center = CGPoint()
            let bounds = self.bounds

            let dimens = CGSize(width: bounds.width * CGFloat(region.width), height: bounds.height * CGFloat(region.height))
            center.x = bounds.width * CGFloat(region.x)
            center.y = bounds.height * CGFloat(region.y) - dimens.height

            let path = NSBezierPath(rect: CGRect(origin: center, size: dimens))
            NSColor.red.withAlphaComponent(CGFloat(0.3)).setFill()
            path.fill()
        }
    }
	
	func fromJSON(_ jsonString: String)
	{
		
	}
	
	func toJSON(_ name: String = "Custom Profile") -> String
	{
		do {
			let dictToConvert: [String: Any] = [
				"name": name,
				"actions": actions.map { $0.serialize() }
			]
			
			let data = try JSONSerialization.data(withJSONObject: dictToConvert, options: .prettyPrinted)
			
			let out = String(data: data, encoding: String.Encoding.utf8)!
			return out
			
		} catch {
			Swift.print("Error creating json export")
		}
		
		return ""
	}
}
