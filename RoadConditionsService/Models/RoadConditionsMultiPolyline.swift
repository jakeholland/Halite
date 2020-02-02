import MapKit

public final class RoadConditionsMultiPolyline: MKMultiPolyline {
    public let roadConditions: RoadConditions
    
    init(polylines: [MKPolyline], roadConditions: RoadConditions) {
        self.roadConditions = roadConditions
        super.init(polylines)
    }
    
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

extension Array where Iterator.Element ==  RoadConditionsMultiPolyline {
    func simplify() -> [RoadConditionsMultiPolyline] {
        var result: [RoadConditionsMultiPolyline] = []

        forEach { segment in
            guard let existingSegmentIndex = result.firstIndex(where: { $0.roadConditions == segment.roadConditions }) else {
                result.append(segment)
                return
            }

            let combinedSegment = RoadConditionsMultiPolyline(polylines: result[existingSegmentIndex].polylines + segment.polylines,
                                                              roadConditions: segment.roadConditions)
            
            result.remove(at: existingSegmentIndex)
            result.insert(combinedSegment, at: existingSegmentIndex)
        }

        return result
    }
}
