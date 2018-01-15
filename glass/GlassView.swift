//
//  GlassView.swift
//  glass
//
//  Created by Ricky Ayoub on 1/15/18.
//

import Foundation
import AppKit

public func processTouchpadData(_ device: Int32, _ data: Optional<UnsafeMutablePointer<Finger>>, _ nFingers: Int32, _ timestamp: Double, _ frame: Int32) -> Int32
{
    let fingers = Array(UnsafeBufferPointer(start: data, count: Int(nFingers)))
    
    view.fingers = fingers
    view.refresh()
    
    return 0;
}

class GlassView : NSView
{
    var fingers: [Finger] = []
    
    func refresh()
    {
        DispatchQueue.main.sync {
            self.needsDisplay = true
        }
    }
    
    override func draw(_ rect: NSRect)
    {
        for finger in fingers
        {
            var center = CGPoint()
            let bounds = self.bounds
            center.x = CGFloat(finger.normalized.pos.x * Float(bounds.width))
            center.y = CGFloat(finger.normalized.pos.y * Float(bounds.height))

            let radius = CGSize(width: CGFloat(finger.size)*20, height: CGFloat(finger.size)*20)

            let path = NSBezierPath(ovalIn: CGRect(origin: center, size: radius))
            NSColor.gray.setFill()
            path.fill()
        }
    }
}
