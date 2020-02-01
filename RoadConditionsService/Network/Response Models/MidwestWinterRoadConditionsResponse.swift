import MapKit

/// https://services.arcgis.com/8lRhdTsQyJpO52F1/arcgis/rest/services/Midwest_Winter_Road_Conditions_View/FeatureServer/0
struct MidwestWinterRoadConditionsResponse: Codable {
    let ROAD_CONDITION: Int?
    
    static func polyline(from geoJsonFeature: MKGeoJSONFeature) -> RoadConditionsMultiPolyline? {
        guard
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(Self.self, from: properties),
            let roadConditionsInt = conditions.ROAD_CONDITION,
            let roadConditions = roadConditions(from: roadConditionsInt)
            else { return nil }

        return RoadConditionsMultiPolyline(geoJsonFeature: geoJsonFeature, roadConditions: roadConditions)
    }
    
    static func roadConditions(from roadConditionsInt: Int) -> RoadConditions? {
        switch roadConditionsInt {
        case 1:
            return .clear
        case 2:
            return .partlyCovered
        case 3:
            return .covered
        case 4:
            return .travelNotAdvised
        case 5:
            return .impassable
        default:
            return nil
        }
    }
}
