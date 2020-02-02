import Combine
import MapKit
import RoadConditionsService

final class RoadConditionsViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    @Published var isLoading: Bool = false
    @Published var isCenteredOnUser: Bool = false
    @Published var roadConditionsSegments: [RoadConditionsMultiPolyline] = []
    
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
                self.roadConditionsSegments = roadConditionsSegments
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
