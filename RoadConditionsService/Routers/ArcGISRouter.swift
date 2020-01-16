import CoreLocation

enum ArcGISRouter: ArcGISEndpointRouter {

    case getIllinoisRoadConditions

    var components: RequestComponents {
        switch self {
        case .getIllinoisRoadConditions:
            return RequestComponents(method: .get, path: "2f8d0b805ed34cfcbbb5c930c5a77e25_0.geojson")
        }
    }
}
