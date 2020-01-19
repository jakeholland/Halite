import SwiftUI

struct BottomCard<Content: View> : View {
    var content: () -> Content
    var body: some View {
        content()
            .frame(width: UIScreen.main.bounds.width, height: 150)
            .background(Color.white)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            .transition(.move(edge: .bottom))
    }
}
