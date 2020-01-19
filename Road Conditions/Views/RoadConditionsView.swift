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
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Road Conditions", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: { self.showLegend.toggle() }) {
                        if showLegend {
                            Image(systemName: "map.fill")
                        } else {
                            Image(systemName: "map")
                        }
                    },
                                trailing:
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
