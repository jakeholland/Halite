import MapKit
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    
    var body: some View {
        MapView(centerCoordinate: $viewModel.centerCoordinate, roadConditionsSegments: $viewModel.roadConditionsSegments)
            .edgesIgnoringSafeArea(.all)
            .onAppear { self.viewModel.loadRoadConditions() }
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
