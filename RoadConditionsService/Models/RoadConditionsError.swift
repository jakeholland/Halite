import Foundation

enum RoadConditionsError: Error {
    case unknown
    case decoding
}

extension RoadConditionsError: LocalizedError {
    var errorDescription: String? { nil }
}
