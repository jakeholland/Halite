import CoreLocation
import MapKit

enum INDOTRouter: INDOTEndpointRouter {

    case getIndianaRoadConditions(in: MKCoordinateRegion)

    var components: RequestComponents {
        switch self {
        case .getIndianaRoadConditions(let region):
            let rect = region.mapRect
            let params: Parameters = [
                "maxBeginDateOffset": 604800000,
                "minEndDateOffset": 0,
                "eventClassifications": ["winterDriving"],
                "zoom": 7,
                "bounds": [
                    "minLat": 37.43899672738482,
                    "minLon": -112.33520515625003,
                    "maxLat": 42.13217881151657,
                    "maxLon": -60.26000984375003
                ],
                "knownKeys": []
            ]

            return RequestComponents(method: .post, path: "eventMapFeatures/updateMap", params: params)
        }
    }
}
