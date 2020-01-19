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
                    .onAppear { self.viewModel.loadRoadConditions() }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Road Conditions", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: self.viewModel.loadRoadConditions) {
                    if viewModel.isLoading {
                        ActivityIndicator()
                    } else {
                        Image(systemName: "arrow.2.circlepath")
                    }
                })
        }
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
