import Foundation
import AppKit

class Shortcut : Result
{
    init(_ shortcut: String)
    {
        super.init()
        
        super.key = shortcut
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    override func toString() -> String {
        return self.key // our representation is just the shortcut name
    }
    
    override func invoke(_ enabled: Bool)
    {
        // run a macos shortcut with the given name
        let shortcutName = self.key
        // use the "shortcuts" command to run the shortcut
        let task = Process()
        task.launchPath = "/usr/bin/shortcuts"
        task.arguments = ["run", shortcutName]
        task.launch()
    }
    
    override func serialize() -> [String: Any]?
    {
        return [
            "type": "Shortcut",
            "shortcut": key,
        ]
    }
}
