import SwiftUI

struct ActionRowView: View {
	let action: Action

	init(action: Action) {
		self.action = action
	}

    var body: some View {
        HStack(alignment: .center) {
            HStack() {
                VStack(alignment: .leading) {
					Text(action.activator.toString())
                        .fontWeight(.bold)
                        .truncationMode(.tail)
					Text(action.context.toString())
                        .font(.caption)
                        .opacity(0.75)
                        .truncationMode(.middle)
                }
                Spacer()
				Text(action.result.toString())
                    .font(.system(size: 20))
                    .frame(minWidth: 100)
            }.frame(maxWidth: 350)
        }
    }
}


struct ActionRowView_Previews: PreviewProvider {
    static var previews: some View {
		ActionRowView(
			action: Action(
				KeyBinding(10),
				Gesture(Gesture.UP, 4)
			)
		)
    }
}
