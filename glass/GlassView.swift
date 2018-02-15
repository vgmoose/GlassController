import Foundation
import AppKit

public func processTouchpadData(_ device: Int32, _ data: Optional<UnsafeMutablePointer<Finger>>, _ nFingers: Int32, _ timestamp: Double, _ frame: Int32) -> Int32
{
    let fingers = Array(UnsafeBufferPointer(start: data, count: Int(nFingers)))
    
    view.fingers = fingers
    view.refresh()
    
    // newly pressed value
    var pressed:Set<Int> = Set()
    
    // if it's in the bottom right, send an S
    for finger in fingers
    {
        if finger.normalized.pos.x > 0.5 && finger.normalized.pos.y > 0.5
        {
            // add 0x01 to the newly "pressed" buttons
            pressed.insert(0x01)
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
    
    var activated = false
    
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
        if !self.activated
        {
            return
        }
        
        let inputKeyCode = CGKeyCode(keyCode)
        let event = CGEvent(keyboardEventSource: nil, virtualKey: inputKeyCode, keyDown: enabled)
        event!.post(tap: .cghidEventTap)
        print("posted S")
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
    }
}
