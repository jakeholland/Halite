import CoreLocation

enum ArcGISRouter: ArcGISEndpointRouter {

    case getIllinoisRoadConditions
    case getIllinoisCountyConditions
    case getMidwestRoadConditions

    var components: RequestComponents {
        switch self {
        case .getIllinoisRoadConditions:
            return RequestComponents(method: .get, path: "2f8d0b805ed34cfcbbb5c930c5a77e25_0.geojson")
        case .getIllinoisCountyConditions:
            return RequestComponents(method: .get, path: "9c9cb328c6064c799698aded4dec8d53_0.geojson")
        case .getMidwestRoadConditions:
            return RequestComponents(method: .get, path: "30453f682b104d33980397c86ef56126.geojson")
        }
    }
}
