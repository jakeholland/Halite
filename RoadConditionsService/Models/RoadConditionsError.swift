import Foundation

enum RoadConditionsError: Error {
    case unknown
}

extension RoadConditionsError: LocalizedError {
    var errorDescription: String? { nil }
}
