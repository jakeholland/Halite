import SwiftUI

public enum RoadConditions: String, CaseIterable {
    case clear = "Clear"
    case partlyCovered = "Partly Covered with ice or snow"
    case mostlyCovered = "Mostly Covered with ice or snow"
    case covered = "Covered with ice or snow"
}

public extension RoadConditions {
    var lineColor: UIColor {
        switch self {
        case .clear:
            return RoadConditions.covered.lineColor
        case .partlyCovered:
            return .init(red:0.87, green:0.92, blue:0.97, alpha:1.0)
        case .mostlyCovered:
            return .init(red:0.62, green:0.79, blue:0.88, alpha:1.0)
        case .covered:
            return .init(red:0.19, green:0.51, blue:0.74, alpha:1.0)
        }
    }
    
    var regionColor: UIColor { lineColor.withAlphaComponent(0.2) }
    
    var view: some View {
        HStack {
            Rectangle()
                .fill(Color(lineColor))
                .frame(width: 40, height: 20)
                .cornerRadius(2)
            Text(rawValue)
                .font(.headline)
        }
    }
}
