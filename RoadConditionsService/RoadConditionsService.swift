import MapKit
import PromiseKit

public struct RoadConditionsService: RoadConditionsServiceProtocol {
    
    public init() { }
    
    public func getRoadConditions(completion: @escaping (Swift.Result<([RoadConditionsMultiPolyline], [RoadConditionsMultiPolygon]), Error>) -> Void) {
        firstly {
            getRoadConditions()
        }.then { roadConditionsMultiPolylines in
            self.getCountyConditions().map { roadConditionsMultiPolygons in
                (roadConditionsMultiPolylines, roadConditionsMultiPolygons)
            }
        }.done { roadConditions in
            completion(.success(roadConditions))
        }.catch { error in
            completion(.failure(error))
        }
    }
}

private extension RoadConditionsService {
    func getRoadConditions() -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: ArcGISRouter = .getIllinoisRoadConditions
            guard let request = components.urlRequest else {
                seal.reject(RoadConditionsError.unknown)
                return
            }
            
            firstly {
                request.responseGeoJsonDecoable()
            }.done { mkGeoJsonArray in
                let roadConditionsSegments = mkGeoJsonArray
                                                .compactMap { $0 as? MKGeoJSONFeature }
                                                .compactMap { RoadConditionsMultiPolyline($0) }
                seal.fulfill(roadConditionsSegments)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getCountyConditions() -> Promise<[RoadConditionsMultiPolygon]> {
        Promise { seal in
            let components: ArcGISRouter = .getIllinoisCountyConditions
            guard let request = components.urlRequest else {
                seal.reject(RoadConditionsError.unknown)
                return
            }
            
            firstly {
                request.responseGeoJsonDecoable()
            }.done { mkGeoJsonArray in
                let roadConditionsRegions = mkGeoJsonArray
                                                .compactMap { $0 as? MKGeoJSONFeature }
                                                .compactMap { RoadConditionsMultiPolygon($0) }
                seal.fulfill(roadConditionsRegions)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

private extension RoadConditionsService {
    func loadMockRoadConditionsSegments() -> [RoadConditionsMultiPolyline] {
        let geoJSONDecoder = MKGeoJSONDecoder()
        guard
            let geoJson = geoJsonData(for: "Test_Road_Conditions"),
            let roadConditions = try? geoJSONDecoder.decode(geoJson)
            else { return [] }
        
        return roadConditions.compactMap { $0 as? MKGeoJSONFeature }.compactMap { RoadConditionsMultiPolyline($0) }
    }
    
    func geoJsonData(for localFileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: localFileName, ofType: "geojson") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}

