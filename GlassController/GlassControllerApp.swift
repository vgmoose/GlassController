import SwiftUI

@main
struct GlassControllerApp: App {
	@NSApplicationDelegateAdaptor(GlassDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
