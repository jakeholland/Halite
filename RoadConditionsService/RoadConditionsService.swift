import MapKit
import PromiseKit

public struct RoadConditionsService: RoadConditionsServiceProtocol {
    
    private let sessionManager: SessionManager
    
    public init(sessionManager: SessionManager = URLSessionManager()) {
        self.sessionManager = sessionManager
    }

    public func getRoadConditions(completion: @escaping (Swift.Result<([RoadConditionsMultiPolyline]), Error>) -> Void) {
        let roadConditionsPromises: [Promise<[RoadConditionsMultiPolyline]>] = [
            getMidwestRoadConditions(),
            getIowaRoadConditions(),
            getIndianaRoadConditions()
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
    func getIndianaRoadConditions() -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: INDOTRouter = .getIndianaRoadConditions
            let request =  Request(urlRequest: components.urlRequest, sessionManager: sessionManager)
             
            firstly {
                request.responseDecodable(IndianaWinterRoadConditions.self)
            }.done { indianaRoadConditions in
                seal.fulfill(indianaRoadConditions.roadConditionsSegments)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getIowaRoadConditions() -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: ArcGISRouter = .getIowaRoadConditions
            let request =  Request(urlRequest: components.urlRequest, sessionManager: sessionManager)
            
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
    
    func getMidwestRoadConditions() -> Promise<[RoadConditionsMultiPolyline]> {
        Promise { seal in
            let components: ArcGISRouter = .getMidwestRoadConditions
            let request =  Request(urlRequest: components.urlRequest, sessionManager: sessionManager)
            
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
