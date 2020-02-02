import MapKit
import PromiseKit

public struct RoadConditionsService: RoadConditionsServiceProtocol {
    
    public init() { }

    public func getRoadConditions(in region: MKCoordinateRegion, completion: @escaping (Swift.Result<([RoadConditionsMultiPolyline]), Error>) -> Void) {
        let roadConditionsPromises: [Promise<[RoadConditionsMultiPolyline]>] = [
            getMidwestRoadConditions(in: region),
            getIowaRoadConditions(in: region)
        ]
        
        when(fulfilled: roadConditionsPromises).done { roadConditionsSegmentArray in
            let roadConditionsSegments = roadConditionsSegmentArray.flatMap { $0 }.simplify()
            completion(.success(roadConditionsSegments))
        }.catch { error in
            completion(.failure(error))
        }
    }
}

// MARK: Private

private extension RoadConditionsService {
    func getIowaRoadConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: ArcGISRouter = .getIowaRoadConditions(in: region)
            guard let request = components.urlRequest else {
                seal.reject(RoadConditionsError.unknown)
                return
            }
            
            firstly {
                request.responseGeoJsonDecoable()
            }.done { mkGeoJsonArray in
                let roadConditionsSegments = mkGeoJsonArray
                    .compactMap { $0 as? MKGeoJSONFeature }
                    .compactMap { IowaWinterRoadConditionsResponse.polyline(from: $0) }
                seal.fulfill(roadConditionsSegments)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getMidwestRoadConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: ArcGISRouter = .getMidwestRoadConditions(in: region)
            guard let request = components.urlRequest else {
                seal.reject(RoadConditionsError.unknown)
                return
            }
            
            firstly {
                request.responseGeoJsonDecoable()
            }.done { mkGeoJsonArray in
                let roadConditionsSegments = mkGeoJsonArray
                    .compactMap { $0 as? MKGeoJSONFeature }
                    .compactMap { MidwestWinterRoadConditionsResponse.polyline(from: $0) }
                seal.fulfill(roadConditionsSegments)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

// MARK: Mock Data

//private extension RoadConditionsService {
//    func loadMockRoadConditionsSegments() -> [RoadConditionsMultiPolyline] {
//        let geoJSONDecoder = MKGeoJSONDecoder()
//        guard
//            let geoJson = geoJsonData(for: "Test_Road_Conditions"),
//            let roadConditions = try? geoJSONDecoder.decode(geoJson)
//            else { return [] }
//
//        return roadConditions.compactMap { $0 as? MKGeoJSONFeature }.compactMap { RoadConditionsMultiPolyline($0) }
//    }
//
//    func geoJsonData(for localFileName: String) -> Data? {
//        guard let path = Bundle.main.path(forResource: localFileName, ofType: "geojson") else { return nil }
//        return try? Data(contentsOf: URL(fileURLWithPath: path))
//    }
//}
