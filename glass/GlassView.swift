import Foundation
import AppKit

extension NSBezierPath {

    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0 ..< elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                continue
            }
        }

        return path
    }
}

class GlassView : NSView
{
    var fingers: [Finger] = []
    var actions: [Action] = []
    
    var gestures: [Action] = []
    var regions: [Action] = []
    
    var pressed:Set<Result> = Set()
	
	let delegate: GlassDelegate
    
//    let STATES = ["NotTracking", "StartInRange", "HoverInRange", "MakeTouch", "Touching", "BreakTouch", "LingerInRange", "OutOfRange", "Unknown1", "Unknown2"]
    
    // roughly? observed range from mashing touchpad
    let MAX_FORCE = 1148125184.0
    let MIN_FORCE = 1065353216.0
    
    let fontAtts = [
        NSAttributedString.Key.font: NSFont.init(
            name: "Helvetica",
            size: 15
        ),
        NSAttributedString.Key.backgroundColor: NSColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.5)
    ]
    
//    var activated = false
	
	override init(frame frameRect: NSRect) {
		self.delegate = GlassDelegate.singleton!
		super.init(frame: frameRect)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
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
		delegate.showPreviewWindow()
    }

    func sendKey(_ result: Result, _ enabled: Bool)
    {
		if !delegate.glassEnabled { return }
        
        // invoke this keybinding, as well as whatever modifiers it has
        result.invoke(enabled)
    }
    
    override func draw(_ rect: NSRect)
    {
        for finger in fingers
        {
            var center = CGPoint()
            let bounds = self.bounds
            
//			let radius = CGSize(width: CGFloat(finger.zTotal)*20, height: CGFloat(finger.zTotal)*20)
            let radius = CGSize(
                width: CGFloat(finger.majorAxis) * 7,
                height: CGFloat(finger.minorAxis) * 7
            )

            center.x = CGFloat(finger.normalizedVector.position.x * Float(bounds.width))
			center.y = CGFloat(finger.normalizedVector.position.y * Float(bounds.height))

            let path = NSBezierPath(ovalIn: CGRect(origin: CGPoint(x: center.x - radius.width/2, y: center.y - radius.height/2), size: radius))
            NSColor.gray.setFill()
            
            let slide1 = AffineTransform(translationByX: -center.x, byY: -center.y)
            let rotation = AffineTransform(rotationByRadians: CGFloat(finger.angle))
            let slide2 = AffineTransform(translationByX: center.x, byY: center.y)
                        
            path.transform(using: slide1)
            path.transform(using: rotation)
            path.transform(using: slide2)
            path.fill()
            
            // draw a velocity vector line
            let velX = CGFloat(finger.normalizedVector.velocity.x) * 50
            let velY = CGFloat(finger.normalizedVector.velocity.y) * 50
            
            let velPath = NSBezierPath()
            velPath.move(to: CGPoint(x: center.x, y: center.y))
            velPath.line(to: NSPoint(x: center.x + velX, y: center.y + velY))
            velPath.lineWidth = 5
            NSColor.orange.setStroke()
            velPath.stroke()
            
            let middle = NSBezierPath(ovalIn: CGRect(origin: CGPoint(x: center.x-2, y: center.y-2), size: CGSize(width: 4, height: 4)))
            NSColor.cyan.setFill()
            middle.fill()
            
            if finger.pressure != 0 {
                // force touchpad, display percent pressed
                let percent = (Double(finger.pressure) - MIN_FORCE) / (MAX_FORCE - MIN_FORCE)
                NSColor.white.setStroke()
                ("\(round(percent * 10000) / 100.0)%" as NSString).draw(
                    at: NSMakePoint(center.x + radius.width / 2, center.y + radius.height / 2),
                     withAttributes: fontAtts)
            }
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
        
        // TODO: copy'd from above, due to Regions and RegionContexts both existing
        for action in gestures
        {
            if let region = action.context as? RegionContext {
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
