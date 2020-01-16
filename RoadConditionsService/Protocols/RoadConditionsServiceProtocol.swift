public protocol RoadConditionsServiceProtocol {
    func getRoadConditions(completion: @escaping (Result<[RoadConditionsSegment], Error>) -> Void)
}
