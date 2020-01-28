import MapKit

public protocol RoadConditionsServiceProtocol {
    func getRoadConditions(in region: MKCoordinateRegion, completion: @escaping (Result<([RoadConditionsMultiPolyline], [RoadConditionsMultiPolygon]), Error>) -> Void)
}
