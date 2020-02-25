import MapKit

public protocol RoadConditionsServiceProtocol {
    func getRoadConditions(completion: @escaping (Result<([RoadConditionsMultiPolyline]), Error>) -> Void)
}
