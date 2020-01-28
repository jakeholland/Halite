import CoreLocation
import MapKit

enum INDOTRouter: INDOTEndpointRouter {

    case getIndianaRoadConditions(rect: MKMapRect)

    var components: RequestComponents {
        switch self {
        case .getIndianaRoadConditions(let rect):
            let params: Parameters = [
                "maxBeginDateOffset": 604800000,
                "minEndDateOffset": 0,
                "eventClassifications": ["winterDriving"],
                "zoom": 7,
                "bounds": [
                    "minLat": rect.minX,
                    "minLon": rect.minY,
                    "maxLat": rect.maxX,
                    "maxLon": rect.maxY
                ],
                "knownKeys": []
            ]

            return RequestComponents(method: .post, path: "eventMapFeatures/updateMap", params: params)
        }
    }
}
