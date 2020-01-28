import SwiftUI

extension AnyTransition {
    static var moveInOut: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
        let removal = AnyTransition.move(edge: .top)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct BottomCard<Content: View> : View {

    var content: () -> Content
    var body: some View {
        content()
            .frame(width: UIScreen.main.bounds.width, height: 160)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.moveInOut)
    }
}
