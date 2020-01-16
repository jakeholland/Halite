import MapKit

public struct RoadConditionsSegment {
    public let roadConditions: RoadConditions
    public let multiPolyline: MKMultiPolyline
}

public extension Array where Element == RoadConditionsSegment {
    var polylines: [MKPolyline] { flatMap { $0.multiPolyline.polylines } }
}

extension RoadConditionsSegment {
    init?(geoJsonFeature: MKGeoJSONFeature) {
        let polylines = geoJsonFeature.geometry.compactMap { $0 as? MKPolyline }
        guard
            !polylines.isEmpty,
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(IllinoisWinterRoadConditionsResponse.self, from: properties),
            let roadConditionsString = conditions.Cond_Desc,
            let roadConditions = RoadConditions(rawValue: roadConditionsString)
            else { return nil }
        
        self.roadConditions = roadConditions
        self.multiPolyline = MKMultiPolyline(polylines)
    }
}
