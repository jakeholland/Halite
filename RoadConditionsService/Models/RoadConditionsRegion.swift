import MapKit

public struct RoadConditionsRegion {
    public let roadConditions: RoadConditions
    public let multiPolygon: MKMultiPolygon
}

public extension Array where Element == RoadConditionsRegion {
    var polygons: [MKPolygon] { flatMap { $0.multiPolygon.polygons } }
}

extension RoadConditionsRegion {
    init?(geoJsonFeature: MKGeoJSONFeature) {
        let polygons = geoJsonFeature.geometry.compactMap { $0 as? MKPolygon }
        guard
            !polygons.isEmpty,
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(IllinoisCountyWinterRoadConditions.self, from: properties),
            let roadConditionsString = conditions.Cond_Desc,
            let roadConditions = RoadConditions(rawValue: roadConditionsString)
            else { return nil }
        
        self.roadConditions = roadConditions
        self.multiPolygon = MKMultiPolygon(polygons)
    }
}
