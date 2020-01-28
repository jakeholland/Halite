import MapKit
import PromiseKit

public struct RoadConditionsService: RoadConditionsServiceProtocol {
    
    public init() { }

    public func getRoadConditions(in region: MKCoordinateRegion, completion: @escaping (Swift.Result<([RoadConditionsMultiPolyline], [RoadConditionsMultiPolygon]), Error>) -> Void) {
        firstly {
            getRoadConditions(in: region)
        }.then { roadConditionsMultiPolylines in
            self.getCountyConditions(in: region).map { roadConditionsMultiPolygons in
                (roadConditionsMultiPolylines, roadConditionsMultiPolygons)
            }
        }.done { roadConditions in
            completion(.success(roadConditions))
        }.catch { error in
            completion(.failure(error))
        }
    }
}

// MARK: Private

private extension RoadConditionsService {
    func getRoadConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolyline]> {
        let roadConditionsPromises: [Promise<[RoadConditionsMultiPolyline]>] = [
            getIllinoisRoadConditions(in: region)
        ]
        return Promise { seal in
            when(fulfilled: roadConditionsPromises).done { roadConditionsSegments in
                seal.fulfill(roadConditionsSegments.flatMap { $0 })
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getCountyConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolygon]> {
        let countyConditionsPromises: [Promise<[RoadConditionsMultiPolygon]>] = [
            getIllinoisCountyConditions(in: region)
        ]
        return Promise { seal in
            when(fulfilled: countyConditionsPromises).done { roadConditionsRegions in
                seal.fulfill(roadConditionsRegions.flatMap { $0 })
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}

// MARK: Illinois

private extension RoadConditionsService {
    func getIllinoisRoadConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolyline]> {
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
    
    func getIllinoisCountyConditions(in region: MKCoordinateRegion) -> Promise<[RoadConditionsMultiPolygon]> {
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

// MARK: Mock Data

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
