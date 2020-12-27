import SwiftUI

struct ActionRowView: View {
    var body: some View {
        HStack(alignment: .center) {
            HStack() {
                VStack(alignment: .leading) {
                    Text("5 Finger Swipe Down")
                        .fontWeight(.bold)
                        .truncationMode(.tail)
                    Text("Global Gesture (Anywhere)")
                        .font(.caption)
                        .opacity(0.75)
                        .truncationMode(.middle)
                }
                Spacer()
                Text("⌃⌘⌥M")
                    .font(.system(size: 20))
                    .frame(minWidth: 100)
            }.frame(maxWidth: 350)
        }
    }
}


struct ActionRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActionRowView()
    }
}
