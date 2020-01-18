import MapKit

public struct RoadConditionsService: RoadConditionsServiceProtocol {
    
    public init() { }
    
    public func getRoadConditions(completion: @escaping (Result<[RoadConditionsSegment], Error>) -> Void) {
        let components: ArcGISRouter = .getIllinoisRoadConditions
        guard let request = components.urlRequest else {
            completion(.failure(RoadConditionsError.unknown))
            return
        }

        request.responseGeoJsonDecoable { result in
            switch result {
            case .success(let mkGeoJsonArray):
                let roadConditionsSegments = mkGeoJsonArray
                                                .compactMap { $0 as? MKGeoJSONFeature }
                                                .compactMap { RoadConditionsSegment(geoJsonFeature: $0) }
                completion(.success(roadConditionsSegments))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCountyConditions(completion: @escaping (Result<[RoadConditionsRegion], Error>) -> Void) {
        let components: ArcGISRouter = .getIllinoisCountyConditions
        guard let request = components.urlRequest else {
            completion(.failure(RoadConditionsError.unknown))
            return
        }

        request.responseGeoJsonDecoable { result in
            switch result {
            case .success(let mkGeoJsonArray):
                let roadConditionsRegions = mkGeoJsonArray
                                                .compactMap { $0 as? MKGeoJSONFeature }
                                                .compactMap { RoadConditionsRegion(geoJsonFeature: $0) }
                completion(.success(roadConditionsRegions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension RoadConditionsService {
    func loadMockRoadConditionsSegments() -> [RoadConditionsSegment] {
        let geoJSONDecoder = MKGeoJSONDecoder()
        guard
            let geoJson = geoJsonData(for: "Test_Road_Conditions"),
            let roadConditions = try? geoJSONDecoder.decode(geoJson)
            else { return [] }
        
        return roadConditions.compactMap { $0 as? MKGeoJSONFeature }.compactMap { RoadConditionsSegment(geoJsonFeature: $0) }
    }
    
    func geoJsonData(for localFileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: localFileName, ofType: "geojson") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}

