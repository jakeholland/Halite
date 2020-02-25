import Foundation
import RoadConditionsService

public final class MockSessionManager: SessionManager {

    private var stubs: [Stub] = []

    public init() { }

    public func responseData(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard
            let url = urlRequest.url,
            let method = HTTPMethod(from: urlRequest.httpMethod),
            let stub = stubs.first(where: { url.relativePath.hasSuffix($0.url) && $0.method == method })
            else { fatalError("Stub not found") }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = jsonData(for: stub.fixture)
        completion(data, response, nil)
    }

    public func add(_ stub: Stub) {
        stubs.append(stub)
    }

    public func removeAllStubs() {
        stubs.removeAll()
    }

    private func jsonData(for fixture: String) -> Data {
        guard
            let path = Bundle(for: Self.self).path(forResource: fixture, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path))
            else { fatalError("Fixture not found") }

        return jsonData
    }
}
