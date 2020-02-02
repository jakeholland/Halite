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
                .zIndex(0)
                .onAppear { self.viewModel.loadRoadConditions() }
            
            GeometryReader { geometry in
                MapButtons(showLegend: self.$showLegend,
                           isLoading: self.$viewModel.isLoading,
                           isCenteredOnUser: self.$viewModel.isCenteredOnUser,
                           loadRoadConditions: self.viewModel.loadRoadConditions)
                    .offset(x: (geometry.size.width / 2) - 40,
                            y: -(geometry.size.height / 2) + 150)
            }
            .zIndex(1)
            
            if showLegend {
                BottomCard {
                    VStack(alignment: .leading) {
                        ForEach(RoadConditions.allCases, id: \.self) { roadConditions in
                            roadConditions.view
                        }
                        Spacer()
                    }
                    .padding()
                }
                .zIndex(3)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct RoadConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        RoadConditionsView()
    }
}
