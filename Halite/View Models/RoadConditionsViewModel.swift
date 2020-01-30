import Combine
import MapKit
import RoadConditionsService

final class RoadConditionsViewModel: ObservableObject {
    
    @Published var centerCoordinate = CLLocationCoordinate2D()
    @Published var region = MKCoordinateRegion()
    @Published var roadConditionsSegments: [RoadConditionsMultiPolyline] = []
    @Published var isLoading: Bool = false
    @Published var isCentered: Bool = false
    
    private let roadConditionsService: RoadConditionsServiceProtocol

    init(roadConditionsService: RoadConditionsServiceProtocol = RoadConditionsService()) {
        self.roadConditionsService = roadConditionsService
    }
    
    func loadRoadConditions() {
        isLoading = true
        roadConditionsService.getRoadConditions(in: region) { result in
            self.isLoading = false
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
}
