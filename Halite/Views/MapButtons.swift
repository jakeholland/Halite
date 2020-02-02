import SwiftUI

struct MapButtons: View {
    
    @Binding var showLegend: Bool
    @Binding var isLoading: Bool
    @Binding var isCenteredOnUser: Bool
    let loadRoadConditions: () -> Void

    private let size: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { self.isCenteredOnUser.toggle() }) {
                if isCenteredOnUser {
                    Image(systemName: "location.fill")
                } else {
                    Image(systemName: "location")
                }
            }
            .frame(width: size, height: size)

            Divider()
            
            Button(action: loadRoadConditions) {
                if isLoading {
                    ActivityIndicator()
                } else {
                    Image(systemName: "arrow.2.circlepath")
                }
            }
            .frame(width: size, height: size)
            .disabled(isLoading)
            
            Divider()

            Button(action: {
                withAnimation() {
                    self.showLegend.toggle()
                }
            }) {
                if showLegend {
                    Image(systemName: "info.circle.fill")
                } else {
                    Image(systemName: "info.circle")
                }
            }
            .frame(width: size, height: size)
        }
        .frame(width: size)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 6)
        .font(Font.system(size: 22).weight(.regular))
    }
}

struct MapButtons_Previews: PreviewProvider {
    static var previews: some View {
        MapButtons(showLegend: .constant(false),
                   isLoading: .constant(false),
                   isCenteredOnUser: .constant(false),
                   loadRoadConditions: { })
    }
}
