public protocol RoadConditionsServiceProtocol {
    func getRoadConditions(completion: @escaping (Result<([RoadConditionsMultiPolyline], [RoadConditionsMultiPolygon]), Error>) -> Void)
}
