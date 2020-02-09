import Foundation

protocol INDOTEndpointRouter: EndpointRouter { }

extension INDOTEndpointRouter {
    var urlRequest: URLRequest? {
        let baseUrlString = "https://indot.carsprogram.org/tgevents/api"

        guard let baseUrl = URL(string: baseUrlString) else { return nil }
        let url = baseUrl.appendingPathComponent(components.path)
        
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let urlWithComponents = urlComponents.url
            else { return nil }

        var urlRequest = URLRequest(url: urlWithComponents)
        urlRequest.httpMethod = components.method.rawValue
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: components.params ?? [:])
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}
