import Foundation
import MapKit

extension URLRequest {
    func responseDecodable<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        return responseDecodable(T.self, completion: completion)
    }
    
    func responseDecodable<T: Decodable>(_ type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        responseData { result in
            switch result {
            case .success(let data):
                guard let decodable = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(RoadConditionsError.unknown))
                     return
                }
                
                completion(.success(decodable))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func responseData(completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: self, completionHandler: { (data, response, error) in
            guard let data = data else {
                completion(.failure(error ?? RoadConditionsError.unknown))
                return
            }
            
            completion(.success(data))
        })
        
        task.resume()
    }

    func responseGeoJsonDecoable(completion: @escaping (Result<[MKGeoJSONObject], Error>) -> Void) {
        responseData { result in
            switch result {
            case .success(let data):
                guard let mkGeoJsonArray = try? MKGeoJSONDecoder().decode(data) else {
                    completion(.failure(RoadConditionsError.unknown))
                     return
                }
                
                completion(.success(mkGeoJsonArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
