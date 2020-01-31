import MapKit

public final class RoadConditionsMultiPolyline: MKMultiPolyline {
    public let roadConditions: RoadConditions
    
    init?(geoJsonFeature: MKGeoJSONFeature, roadConditions: RoadConditions) {
        self.roadConditions = roadConditions
        
        let polylines = geoJsonFeature.geometry.compactMap { $0 as? MKPolyline }
        guard !polylines.isEmpty else {
            let multiPolylines = geoJsonFeature.geometry.compactMap { $0 as? MKMultiPolyline }
            let polylines = multiPolylines.flatMap { $0.polylines }
            super.init(polylines)
            return
        }
        
        super.init(polylines)
    }
}

public extension Array where Element == RoadConditionsMultiPolyline {
    var polylines: [MKPolyline] { flatMap { $0.polylines } }
}
