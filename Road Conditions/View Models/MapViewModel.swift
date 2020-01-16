import Combine
import MapKit
import RoadConditionsService

final class MapViewModel: ObservableObject {
    
    @Published var roadConditionsSegments: [RoadConditionsSegment] = []
    
    private let roadConditionsService: RoadConditionsServiceProtocol

    init(roadConditionsService: RoadConditionsServiceProtocol = RoadConditionsService()) {
        self.roadConditionsService = roadConditionsService
        loadRoadConditions()
    }
    
    func loadRoadConditions() {
        roadConditionsService.getRoadConditions { result in
            switch result {
            case .success(let roadConditionsSegments):
                self.roadConditionsSegments = roadConditionsSegments
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func roadConditionsSegment(for polyline: MKPolyline) -> RoadConditionsSegment? {
        roadConditionsSegments.first(where: { $0.multiPolyline.polylines.contains(polyline) })
    }

}
