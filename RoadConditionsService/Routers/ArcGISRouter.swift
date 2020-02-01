import CoreLocation
import MapKit

enum ArcGISRouter: ArcGISEndpointRouter {

    case getMidwestRoadConditions(in: MKCoordinateRegion)
    case getIowaRoadConditions(in: MKCoordinateRegion)

    var components: RequestComponents {
        switch self {
        case .getMidwestRoadConditions(let region):
            let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2),
                                                 longitude: region.center.longitude - (region.span.longitudeDelta/2))
            let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2),
                                                     longitude: region.center.longitude + (region.span.longitudeDelta/2))

            let params: Parameters = [
                "geometry": "\(topLeft),\(bottomRight)"
            ]
            return RequestComponents(method: .get, path: "30453f682b104d33980397c86ef56126_0.geojson")
        case .getIowaRoadConditions(let region):
            return RequestComponents(method: .get, path: "181770a5c1bf498797245c13afffa155_0.geojson")
        }
    }
}
