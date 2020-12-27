import Foundation
import AppKit

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
    
	@objc func showGlass()
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
