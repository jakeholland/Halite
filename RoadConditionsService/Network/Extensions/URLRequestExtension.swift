import Foundation
import MapKit
import PromiseKit

extension URLRequest {
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
    
    func responseData() -> Promise<Data> {
        Promise { seal in
            let task = URLSession.shared.dataTask(with: self, completionHandler: { (data, response, error) in
                guard let data = data else {
                    seal.reject(error ?? RoadConditionsError.unknown)
                    return
                }
                
                seal.fulfill(data)
            })
            
            task.resume()
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
