import CoreLocation
import MapKit

enum ArcGISRouter: ArcGISEndpointRouter {
    case getMidwestRoadConditions
    case getIowaRoadConditions

    var components: RequestComponents {
        switch self {
        case .getMidwestRoadConditions:
            return RequestComponents(method: .get, path: "30453f682b104d33980397c86ef56126_0.geojson")
        case .getIowaRoadConditions:
            return RequestComponents(method: .get, path: "181770a5c1bf498797245c13afffa155_0.geojson")
        }
    }
}
