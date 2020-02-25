import Foundation

protocol EndpointRouter {
    var components: RequestComponents { get }
    var urlRequest: URLRequest { get }
}

extension Parameters {
    var queryItems: [URLQueryItem] { return compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") } }
}
