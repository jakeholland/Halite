struct IndianaWinterRoadConditions: Decodable {
    let add: [IndianaWinterRoadCondition]
}

struct IndianaWinterRoadCondition: Decodable {
    let id: String
    let key: String
    let geometry: IndianaWinterGeometry
    let representation: IndianaWinterRepresentation
    let priority: Int
    let tooltip: String
}

enum GeometryType: String, Decodable {
    case lineString = "LineString"
}

struct IndianaWinterGeometry: Decodable {
    let type: GeometryType
    let coordinates: [[Double]]
}

enum IndianaWinterRoadConditionColor: String, Decodable {
    case good = "#999999"
    case fair = "#0099FF"
}

struct IndianaWinterRepresentation: Decodable {
    let color: IndianaWinterRoadConditionColor
}

//{
//    "id": "INSEG-378749",
//    "key": "INSEG-378749.4@7",
//    "geometry": {
//        "type": "LineString",
//        "coordinates": [
//            [-86.189803, 40.578848],
//            [-86.283522, 40.72344],
//            [-86.307336, 40.730261]
//        ]
//    },
//    "detours": [],
//    "bounds": {
//        "minLat": 40.578847736763564,
//        "minLon": -86.30733587,
//        "maxLat": 40.73026079,
//        "maxLon": -86.18980262630141
//    },
//    "representation": {
//        "color": "#999999",
//        "iconProperties": {
//            "image": "/tg_in_good_driving.gif",
//            "width": 14,
//            "height": 14
//        },
//        "extentAlwaysVisible": true,
//        "hideIcon": true,
//        "displayConditions": {
//            "zoomLevelRange": {
//                "min": 1,
//                "max": 21
//            }
//        },
//        "includeTrafficDisplay": true
//    },
//    "priority": 5,
//    "tooltip": "US 35: Good driving conditions, dry pavement, partly cloudy."
//}
