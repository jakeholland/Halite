import SwiftUI

extension AnyTransition {
    static var moveInOut: AnyTransition {
        let insertion: AnyTransition = .move(edge: .bottom)
        let removal: AnyTransition = .opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct BottomCard<Content: View> : View {
    var content: () -> Content
    var body: some View {
        content()
            .frame(width: min(UIScreen.main.bounds.width, 400), height: 190)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.move(edge: .bottom))
    }
}
