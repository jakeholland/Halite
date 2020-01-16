import SwiftUI

public enum RoadConditions: String {
    case clear = "Clear"
    case partlyCovered = "Partly Covered with ice or snow"
    case mostlyCovered = "Mostly Covered with ice or snow"
    case covered = "Covered with ice or snow"
}

public extension RoadConditions {
    var color: UIColor {
        switch self {
        case .clear:
            return .black
        case .partlyCovered:
            return .lightGray
        case .mostlyCovered:
            return .gray
        case .covered:
            return .blue
        }
    }
}
