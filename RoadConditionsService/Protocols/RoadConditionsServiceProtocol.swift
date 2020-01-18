public protocol RoadConditionsServiceProtocol {
    func getRoadConditions(completion: @escaping (Result<[RoadConditionsSegment], Error>) -> Void)
    func getCountyConditions(completion: @escaping (Result<[RoadConditionsRegion], Error>) -> Void)
}
