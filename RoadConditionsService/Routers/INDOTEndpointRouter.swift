import Foundation

protocol INDOTEndpointRouter: EndpointRouter { }

extension INDOTEndpointRouter {
    var urlRequest: URLRequest? {
        let baseUrlString = "https://indot.carsprogram.org/tgevents/api"

        guard let baseUrl = URL(string: baseUrlString) else { return nil }
        let url = baseUrl.appendingPathComponent(components.path)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }

        urlComponents.queryItems = components.queries?.queryItems ?? []

        guard let urlWithComponents = urlComponents.url else { return nil }

        var urlRequest = URLRequest(url: urlWithComponents)

        urlRequest.httpMethod = components.method.rawValue

        if let parameters = components.params {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        } else {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }

        return urlRequest
    }

}
