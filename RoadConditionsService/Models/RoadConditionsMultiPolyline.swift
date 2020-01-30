import MapKit

public final class RoadConditionsMultiPolyline: MKMultiPolyline {
    public let roadConditions: RoadConditions
    
    init?(_ geoJsonFeature: MKGeoJSONFeature) {
        guard let roadConditions = RoadConditions(from: geoJsonFeature) else { return nil }
        
        self.roadConditions = roadConditions
        
        let polylines = geoJsonFeature.geometry.compactMap { $0 as? MKPolyline }
        guard !polylines.isEmpty else {
            let multiPolylines = geoJsonFeature.geometry.compactMap { $0 as? MKMultiPolyline }
            let polylines = multiPolylines.flatMap { $0.polylines }
            super.init(polylines)
            return
        }
        
        super.init(polylines)
    }
}

public extension Array where Element == RoadConditionsMultiPolyline {
    var polylines: [MKPolyline] { flatMap { $0.polylines } }
}

private extension RoadConditions {
    init?(from geoJsonFeature: MKGeoJSONFeature) {
        guard
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(MidwestWinterRoadConditionsResponse.self, from: properties),
            let roadConditionsInt = conditions.ROAD_CONDITION
            else { return nil }
        
        switch roadConditionsInt {
        case 0:
            self = .clear
        case 1:
            self = .partlyCovered
        default:
            return nil
        }
    }
}
