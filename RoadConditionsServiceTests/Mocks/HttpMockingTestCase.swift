import XCTest

open class HttpMockingTestCase: XCTestCase {
    public let mockSessionManager = MockSessionManager()

    override open func tearDown() {
        mockSessionManager.removeAllStubs()
        super.tearDown()
    }
}

public enum HTTPMethod {
    case get, put, post, delete

    init?(from string: String?) {
        switch string {
        case "GET":
            self = .get
        case "PUT":
            self = .put
        case "POST":
            self = .post
        case "DELETE":
            self = .delete
        default:
            return nil
        }
    }
}

public extension HttpMockingTestCase {
    func stub(_ httpMethod: HTTPMethod, _ url: String, fixture: String) {
        let stub = Stub(url: url, method: httpMethod, fixture: fixture)
        mockSessionManager.add(stub)
    }

}
