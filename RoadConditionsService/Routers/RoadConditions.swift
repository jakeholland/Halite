import SwiftUI

public enum RoadConditions: String, CaseIterable {
    case clear = "Clear"
    case partlyCovered = "Partly covered with ice or snow"
    case covered = "Covered with ice or snow"
    case travelNotAdvised = "Travel Not Advised"
    case impassable = "Impassable"
}

public extension RoadConditions {
    var lineColor: UIColor? {
        switch self {
        case .clear:
            return .systemGreen
        case .partlyCovered:
            return .init(red: 0.87, green: 0.92, blue: 0.97, alpha: 1.0)
        case .covered:
            return .init(red: 0.62, green: 0.79, blue: 0.88, alpha: 1.0)
        case .travelNotAdvised:
            return .init(red: 0.19, green: 0.51, blue: 0.74, alpha: 1.0)
        case .impassable:
            return .black
        }
    }
    
    var regionColor: UIColor? { lineColor?.withAlphaComponent(0.5) }
    
    var view: some View {
        HStack {
            Rectangle()
                .fill(Color(lineColor ?? .clear))
                .frame(width: 40, height: 20)
                .cornerRadius(2)
            Text(rawValue)
                .font(.headline)
        }
    }
}
