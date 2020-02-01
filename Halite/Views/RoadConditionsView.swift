import MapKit
import RoadConditionsService
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    @State private var showLegend: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(region: $viewModel.region,
                    roadConditionsSegments: $viewModel.roadConditionsSegments,
                    isCenteredOnUser: $viewModel.isCenteredOnUser)
                .onAppear { self.viewModel.loadRoadConditions() }
            
            GeometryReader { geometry in
                MapButtons(showLegend: self.$showLegend,
                           isLoading: self.$viewModel.isLoading,
                           isCenteredOnUser: self.$viewModel.isCenteredOnUser,
                           loadRoadConditions: self.viewModel.loadRoadConditions)
                .offset(x: (geometry.size.width / 2) - 40,
                        y: -(geometry.size.height / 2) + 150)
            }
            
            if showLegend {
                BottomCard {
                    VStack(alignment: .leading) {
                        RoadConditions.clear.view
                        RoadConditions.partlyCovered.view
                        RoadConditions.covered.view
                        RoadConditions.travelNotAdvised.view
                        RoadConditions.impassable.view
                        Spacer()
                    }.padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
