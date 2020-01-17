import MapKit
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, roadConditionsSegments: $viewModel.roadConditionsSegments)
            .edgesIgnoringSafeArea(.all)
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
