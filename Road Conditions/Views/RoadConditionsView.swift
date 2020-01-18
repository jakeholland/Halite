import MapKit
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    @State private var xPosition: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                MapView(centerCoordinate: $viewModel.centerCoordinate,
                        roadConditionsSegments: $viewModel.roadConditionsSegments,
                        roadConditionsRegions: $viewModel.roadConditionsRegions)
                    .onAppear { self.viewModel.loadConditions() }
                
    //            if viewModel.isLoading {
    //                VStack {
    //                    GeometryReader { metrics in
    //                        Rectangle()
    //                            .foregroundColor(.blue)
    //                            .frame(width: metrics.size.width * 0.3, height: 3)
    //                            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true))
    ////                            .offset(x: self.xPosition - metrics.size.width / 2, y: -(metrics.size.height / 2) + 3)
    //                            .onAppear { self.xPosition = metrics.size.width }
    //                    }
    //                    Spacer()
    //                }
    //            }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Road Conditions", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: self.viewModel.loadConditions) {
                             Image(systemName: "arrow.2.circlepath")
                        })
        }
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
