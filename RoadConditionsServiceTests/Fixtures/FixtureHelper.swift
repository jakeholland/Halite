import Foundation
import MapKit
@testable import RoadConditionsService

enum FixtureHelper {
    static func loadMockRoadConditionsSegments(for filename: String) -> [RoadConditionsMultiPolyline] {
        let geoJSONDecoder = MKGeoJSONDecoder()
        guard
            let geoJson = geoJsonData(for: filename),
            let roadConditions = try? geoJSONDecoder.decode(geoJson)
            else { return [] }
        
        return []
//        return roadConditions.compactMap { $0 as? MKGeoJSONFeature }.compactMap { RoadConditionsMultiPolyline( }
    }
    
    static private func geoJsonData(for localFileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: localFileName, ofType: "geojson") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
