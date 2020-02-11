import MapKit
import RoadConditionsService

final class MockRoadConditionsService: RoadConditionsServiceProtocol {
    
    var errorToReturn: Error?
    var conditionsToReturn: [RoadConditionsMultiPolyline] = []
    
    func getRoadConditions(completion: @escaping (Result<([RoadConditionsMultiPolyline]), Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(conditionsToReturn))
        }
    }
}
