import Foundation
import MapKit
import PromiseKit

extension Request {
    func responseDecodable<T: Decodable>() -> Promise<T> {
        responseDecodable(T.self)
    }
    
    func responseDecodable<T: Decodable>(_ type: T.Type) -> Promise<T> {
        Promise { seal in
            firstly {
             responseData()
           }.done { data in
               guard let decodable = try? JSONDecoder().decode(T.self, from: data) else {
                   seal.reject(RoadConditionsError.decoding)
                   return
               }
               seal.fulfill(decodable)
           }.catch { error in
               seal.reject(error)
           }
        }
    }

    func responseGeoJsonDecoable() -> Promise<[MKGeoJSONObject]> {
        Promise { seal in
            firstly {
              responseData()
            }.done { data in
                guard let mkGeoJsonArray = try? MKGeoJSONDecoder().decode(data) else {
                    seal.reject(RoadConditionsError.decoding)
                    return
                }
                seal.fulfill(mkGeoJsonArray)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
