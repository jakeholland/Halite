import MapKit

struct IndianaWinterRoadConditions: Decodable {
    let add: [IndianaWinterRoadCondition]
    var roadConditionsSegments: [RoadConditionsMultiPolyline] { add.compactMap { $0.polyline } }
}

struct IndianaWinterRoadCondition: Decodable {
    let id: String
    let key: String
    let geometry: IndianaWinterGeometry
    let representation: IndianaWinterRepresentation
    let priority: Int
    let tooltip: String
    
    var polyline: RoadConditionsMultiPolyline? {
        guard let roadConditions = representation.roadConditions else { return nil }
        return RoadConditionsMultiPolyline(polylines: [geometry.polyline], roadConditions: roadConditions)
    }
    
}

struct IndianaWinterGeometry: Decodable {
    let polyline: MKPolyline
    
    private enum CodingKeys: String, CodingKey {
        case coordinates
    }
}

extension IndianaWinterGeometry {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let coordinateArray = try? values.decode([[CLLocationDegrees]].self, forKey: .coordinates) else {
            polyline = MKPolyline()
            return
        }
        
        let coordinates: [CLLocationCoordinate2D] = coordinateArray.compactMap { coordinate in
            guard coordinate.count == 2 else { return nil }
            return CLLocationCoordinate2D(latitude: coordinate[1], longitude: coordinate[0])
        }

        polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}

struct IndianaWinterRepresentation: Decodable {
    let iconProperties: IndianaIconProperties
    var roadConditions: RoadConditions? {
        switch iconProperties.image {
        case "/tg_in_good_driving.gif":
            return .clear
        case "/tg_in_fair_driving.gif":
            return .partlyCovered
        case "/tg_in_difficult_hazardous_driving.gif":
            return .covered
        case "/closure_legend.gif":
            return .impassable
        default:x
            return nil
        }
    }
}

struct IndianaIconProperties: Decodable {
    let image: String
}
