import SwiftUI

func delete(index: IndexSet) {
    print("Deleted")
}

struct ContentView: View {
    @State var actions: [Action] = []
    
    var body: some View {
        VStack {
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
            ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(actions, id: \.self) { action in
                    ActionRowView(action: action).padding()
                }
            }.padding()
        }
        }.onAppear {
            // wait a few seconds and then update a state variable to trigger a re-render
            // TODO: get rid of this when removing the old Preferences window
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let glassView = GlassPreferences.glassViewSingleton {
                    self.actions = glassView.actions
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
