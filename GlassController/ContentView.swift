import SwiftUI

let food = ["Spaghetti", "Fried Rice"]

func delete(index: IndexSet) {
    print("Deleted")
}

struct ContentView: View {
    var body: some View {
        Text("This app allows you to configure different actions (such as key bindings) depending on gestures/input from the touchpad.").padding()
		HStack {
			Button(action: {
				GlassDelegate.glassView!.showGlass()
			}) {
				Text("Touchpad Preview")
			}.padding()
			Button(action: {
				NSWorkspace.shared.open(URL(string: "https://github.com/vgmoose/GlassController")!)
			}) {
				Text("Source Code")
			}.padding()
		}
        HStack() {
            Text("Select Profile")
//            Dropdown(["hi", "no"])
        }
        Text("Actions in this Profile")
            .font(.system(size: 16))
            .bold()
        ScrollView(.horizontal) {
            ForEach(food, id: \.self) { data in
                ActionRowView(action: Action(
					KeyBinding(10),
				 Gesture(Gesture.UP, 4)
			 )).padding()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
