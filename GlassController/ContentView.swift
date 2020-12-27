import SwiftUI

let food = ["Spaghetti", "Cheese Burger", "Pizza", "Fried Rice", "Spaghetti", "Cheese Burger", "Pizza", "Fried Rice"]

func delete(index: IndexSet) {
    print("Deleted")
}

struct ContentView: View {
    var body: some View {
        Text("This app allows you to configure different actions (such as key bindings) depending on gestures/input from the touchpad.").padding()
        Button(action: {
            print("ello")
        }) {
            Text("License")
        }.padding()
        HStack() {
            Text("Select Profile")
//            Dropdown(["hi", "no"])
        }
        Text("Actions in this Profile")
            .font(.system(size: 16))
            .bold()
        ScrollView(.horizontal) {
            ForEach(food, id: \.self) { data in
                ActionRowView().padding()
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
