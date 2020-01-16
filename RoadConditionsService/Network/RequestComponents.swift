enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

typealias Parameters = [String: Any]

struct RequestComponents {
    let method: HTTPMethod
    let path: String
    let params: Parameters?
    let queries: Parameters?
    
    init(method: HTTPMethod, path: String, params: Parameters? = nil, queries: Parameters? = nil) {
        self.method = method
        self.path = path
        self.params = params
        self.queries = queries
    }
}
 
