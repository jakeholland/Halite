import SwiftUI

struct BottomCard<Content: View> : View {
    var content: () -> Content
    var body: some View {
        content()
            .frame(width: UIScreen.main.bounds.width, height: 140)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .animation(.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 10))
            .transition(.move(edge: .bottom))
    }
}
