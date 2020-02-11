import CoreLocation
import MapKit

enum INDOTRouter: INDOTEndpointRouter {

    case getIndianaRoadConditions

    var components: RequestComponents {
        switch self {
        case .getIndianaRoadConditions:
            let params: Parameters = [
                "maxBeginDateOffset": 604800000,
                "minEndDateOffset": 0,
                "eventClassifications": ["winterDriving"],
                "zoom": 7,
                "bounds": [
                    "minLat": 37.7718,
                    "minLon": -88.098,
                    "maxLat": 41.7611,
                    "maxLon": -84.809
                ],
                "knownKeys": []
            ]

            return RequestComponents(method: .post, path: "eventMapFeatures/updateMap", params: params)
        }
    }
}
