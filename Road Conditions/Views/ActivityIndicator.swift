import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding private var isAnimating: Bool
    private let style: UIActivityIndicatorView.Style
    
    init(style: UIActivityIndicatorView.Style = .medium, isAnimating: Binding<Bool> = .constant(true)) {
        self.style = style
        self._isAnimating = isAnimating
    }

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
