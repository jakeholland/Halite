import Foundation

public protocol SessionManager {
    func responseData(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
