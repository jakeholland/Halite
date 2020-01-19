import MapKit
import RoadConditionsService
import SwiftUI

struct RoadConditionsView: View {
    
    @ObservedObject var viewModel = RoadConditionsViewModel()
    @State private var xPosition: CGFloat = 0
    @State private var showLegend: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapView(centerCoordinate: $viewModel.centerCoordinate,
                        roadConditionsSegments: $viewModel.roadConditionsSegments,
                        roadConditionsRegions: $viewModel.roadConditionsRegions)
                    .onAppear { self.viewModel.loadRoadConditions() }
                GeometryReader { geometry in
                    MapButtons(showLegend: self.$showLegend,
                               isLoading: self.$viewModel.isLoading,
                               isCentered: self.$viewModel.isCentered,
                               loadRoadConditions: self.viewModel.loadRoadConditions)
                    .offset(x: (geometry.size.width / 2) - 40, y: -(geometry.size.height / 2) + 130)
                }
                
                if showLegend {
                    BottomCard {
                        VStack(alignment: .leading) {
                            RoadConditions.partlyCovered.view
                            RoadConditions.mostlyCovered.view
                            RoadConditions.covered.view
                            Spacer()
                        }.padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
