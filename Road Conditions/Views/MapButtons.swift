import SwiftUI

struct MapButtons: View {
    
    @Binding var showLegend: Bool
    @Binding var isLoading: Bool
    @Binding var isCentered: Bool
    let loadRoadConditions: () -> Void

    private let size: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { self.loadRoadConditions() }) {
                if isCentered {
                    Image(systemName: "location.fill")
                } else {
                    Image(systemName: "location")
                }
            }.frame(height: size)
            
            Divider()
            
            Button(action: loadRoadConditions) {
                if isLoading {
                    ActivityIndicator()
                } else {
                    Image(systemName: "arrow.2.circlepath")
                }
            }
            .frame(height: size)
            .disabled(isLoading)
            
            Divider()

            Button(action: { self.showLegend.toggle() }) {
                if showLegend {
                    Image(systemName: "info.circle.fill")
                } else {
                    Image(systemName: "info.circle")
                }
            }.frame(height: size)
        }
        .frame(width: size)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 0.5)
        )
        .shadow(radius: 10)
    }
}

struct MapButtons_Previews: PreviewProvider {
    static var previews: some View {
        MapButtons(showLegend: .constant(false),
                   isLoading: .constant(false),
                   isCentered: .constant(false),
                   loadRoadConditions: { })
    }
}
