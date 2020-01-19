import MapKit

public final class RoadConditionsMultiPolygon: MKMultiPolygon {
    public let roadConditions: RoadConditions
    
    public init?(_ geoJsonFeature: MKGeoJSONFeature) {
        let polygons = geoJsonFeature.geometry.compactMap { $0 as? MKPolygon }
        guard
            !polygons.isEmpty,
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(IllinoisCountyWinterRoadConditions.self, from: properties),
            let roadConditionsString = conditions.Cond_Desc,
            let roadConditions = RoadConditions(rawValue: roadConditionsString)
            else { return nil }
        
        self.roadConditions = roadConditions
        super.init(polygons)
    }
}

public extension Array where Element == RoadConditionsMultiPolygon {
    var polygons: [MKPolygon] { flatMap { $0.polygons } }
}
