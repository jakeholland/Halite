import Combine
import Foundation
import MapKit
import RoadConditionsService

final class RoadConditionsViewModel: ObservableObject {
    
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var roadConditionsSegments: [RoadConditionsMultiPolyline] = []
    @Published var roadConditionsRegions: [RoadConditionsMultiPolygon] = []
    @Published var isLoading: Bool = false
    @Published var isCentered: Bool = false
    
    private let roadConditionsService: RoadConditionsServiceProtocol

    init(roadConditionsService: RoadConditionsServiceProtocol = RoadConditionsService()) {
        self.roadConditionsService = roadConditionsService
    }
    
    func loadRoadConditions() {
        isLoading = true
        roadConditionsService.getRoadConditions { result in
            self.isLoading = false
            switch result {
            case .success(let roadConditionsSegments, let roadConditionsRegions):
                DispatchQueue.main.async {
                    self.roadConditionsSegments = roadConditionsSegments
                    self.roadConditionsRegions = roadConditionsRegions
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
