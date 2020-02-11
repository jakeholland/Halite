import Foundation

public struct URLSessionManager: SessionManager {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func responseData(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlSession.dataTask(with: urlRequest, completionHandler: completion).resume()
    }
}
