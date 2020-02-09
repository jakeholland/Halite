import Foundation

protocol ArcGISEndpointRouter: EndpointRouter { }

extension ArcGISEndpointRouter {
    var urlRequest: URLRequest? {
        let baseUrlString = "https://opendata.arcgis.com/datasets/"

        guard let baseUrl = URL(string: baseUrlString) else { return nil }
        let url = baseUrl.appendingPathComponent(components.path)
        
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let urlWithComponents = urlComponents.url
            else { return nil }

        var urlRequest = URLRequest(url: urlWithComponents)
        urlRequest.httpMethod = components.method.rawValue

        return urlRequest
    }

}
