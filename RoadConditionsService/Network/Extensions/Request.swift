import Foundation
import PromiseKit

struct Request {
    let urlRequest: URLRequest
    let sessionManager: SessionManager
    
    init(urlRequest: URLRequest, sessionManager: SessionManager) {
        self.urlRequest = urlRequest
        self.sessionManager = sessionManager
    }
    
    func responseData() -> Promise<Data> {
        Promise { seal in
            sessionManager.responseData(urlRequest: urlRequest) { (data, response, error) in
                guard let data = data else {
                    seal.reject(error ?? RoadConditionsError.unknown)
                    return
                }
                seal.fulfill(data)
            }
        }
    }
}
