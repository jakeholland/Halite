import MapKit
@testable import RoadConditionsService

final class MockRoadConditionsMultiPolyline: RoadConditionsMultiPolyline {
    init(roadConditions: RoadConditions = .partlyCovered) {
        super.init(polylines: [MKPolyline()], roadConditions: roadConditions)
    }
}

extension Array where Element == MockRoadConditionsMultiPolyline {
    static let mock: [MockRoadConditionsMultiPolyline] = [
        MockRoadConditionsMultiPolyline(roadConditions: .clear),
        MockRoadConditionsMultiPolyline(roadConditions: .partlyCovered),
        MockRoadConditionsMultiPolyline(roadConditions: .covered),
        MockRoadConditionsMultiPolyline(roadConditions: .travelNotAdvised),
        MockRoadConditionsMultiPolyline(roadConditions: .impassable)
    ]
}
