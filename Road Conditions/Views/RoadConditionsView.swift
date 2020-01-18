import MapKit
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    
    var body: some View {
        MapView(centerCoordinate: $viewModel.centerCoordinate,
                roadConditionsSegments: $viewModel.roadConditionsSegments,
                roadConditionsRegions: $viewModel.roadConditionsRegions)
            .edgesIgnoringSafeArea(.all)
            .onAppear { self.viewModel.loadConditions() }
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
