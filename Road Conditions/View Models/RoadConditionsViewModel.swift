import Combine
import Foundation
import MapKit
import RoadConditionsService

final class RoadConditionsViewModel: ObservableObject {
    
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var roadConditionsSegments: [RoadConditionsSegment] = []
    @Published var roadConditionsRegions: [RoadConditionsRegion] = []
    
    private let roadConditionsService: RoadConditionsServiceProtocol

    init(roadConditionsService: RoadConditionsServiceProtocol = RoadConditionsService()) {
        self.roadConditionsService = roadConditionsService
    }
    
    func loadConditions() {
        loadRoadConditions()
        loadCountyConditions()
    }
    
    private func loadRoadConditions() {
        roadConditionsService.getRoadConditions { result in
            switch result {
            case .success(let roadConditionsSegments):
                DispatchQueue.main.async {
                    self.roadConditionsSegments = roadConditionsSegments
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadCountyConditions() {
        roadConditionsService.getCountyConditions { result in
            switch result {
            case .success(let roadConditionsRegions):
                DispatchQueue.main.async {
                    self.roadConditionsRegions = roadConditionsRegions
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
