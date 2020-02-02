import MapKit

/// https://services.arcgis.com/8lRhdTsQyJpO52F1/arcgis/rest/services/511_IA_Road_Conditions_View/FeatureServer/0
struct IowaWinterRoadConditionsResponse: Codable {
    let OBJECTID: Int
    let ROAD_CONDITION: String?
    
    static func polyline(from geoJsonFeature: MKGeoJSONFeature) -> RoadConditionsMultiPolyline? {
        guard
            let properties = geoJsonFeature.properties,
            let conditions = try? JSONDecoder().decode(Self.self, from: properties),
            let roadConditionsString = conditions.ROAD_CONDITION,
            let roadConditions = roadConditions(from: roadConditionsString)
            else { return nil }

        return RoadConditionsMultiPolyline(geoJsonFeature: geoJsonFeature, roadConditions: roadConditions)
    }
    
    static func roadConditions(from roadConditionsString: String) -> RoadConditions? {
        switch roadConditionsString {
        case "Seasonal":
            return .clear
        case "Partially Covered":
            return .partlyCovered
        case "Completely Covered":
            return .covered
        case "Travel Not Advised":
            return .travelNotAdvised
        case "Impassable":
            return .impassable
        default:
            return nil
        }
    }
}
