import Foundation

struct MockError: Error {
    private let text: String
    
    init(text: String = "test error") {
        self.text = text
    }
}

extension MockError: Equatable { }

extension MockError: LocalizedError {
    var errorDescription: String? { text }
}

