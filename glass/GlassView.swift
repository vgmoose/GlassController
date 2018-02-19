import Foundation
import AppKit

// detect if a circle is intersecting with a rectangle
func intersects(_ cx: Double, _ cy: Double, _ left: Double, _ top: Double, _ right: Double, _ bottom: Double) -> Bool
{
    return cx >= left && cx <= right && cy >= top && cy <= bottom
}

public func processTouchpadData(_ device: Int32, _ data: Optional<UnsafeMutablePointer<Finger>>, _ nFingers: Int32, _ timestamp: Double, _ frame: Int32) -> Int32
{
    let fingers = Array(UnsafeBufferPointer(start: data, count: Int(nFingers)))
    
    view.fingers = fingers
    view.refresh()
    
    // newly pressed value
    var pressed:Set<Int> = Set()
    
    // if it's the first region, send an S
    for finger in fingers
    {
        for region in glassView.regions
        {
            if intersects(Double(finger.normalized.pos.x), Double(finger.normalized.pos.y), region.x, region.y - region.height, region.x + region.width, region.y)
            {
                // add 0x01 to the newly "pressed" buttons
                pressed.insert(0x01)
            }
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
    var regions: [Region] = []
    var pressed:Set<Int> = Set()
    
//    var activated = false
    
    func refresh()
    {
        DispatchQueue.main.sync {
            self.needsDisplay = true
        }
    }
    
    func showGlass()
    {
        showPreviewWindow()
    }
    
    func sendKey(_ keyCode: Int, _ enabled: Bool)
    {
        if !glassEnabled
        {
            return
        }
        
        let inputKeyCode = CGKeyCode(keyCode)
        let event = CGEvent(keyboardEventSource: nil, virtualKey: inputKeyCode, keyDown: enabled)
        event!.post(tap: .cghidEventTap)
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
        
        for region in regions
        {
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
}
