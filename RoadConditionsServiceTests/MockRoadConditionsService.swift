import MapKit
import RoadConditionsService

struct MockRoadConditionsSercice: RoadConditionsServiceProtocol {
    func getRoadConditions(in region: MKCoordinateRegion, completion: @escaping (Result<([RoadConditionsMultiPolyline]), Error>) -> Void) {
        
    }
}
