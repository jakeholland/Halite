import SwiftUI

public enum RoadConditions: String, CaseIterable {
    case clear = "Clear"
    case partlyCovered = "Partly Covered with ice or snow"
    case mostlyCovered = "Mostly Covered with ice or snow"
    case covered = "Covered with ice or snow"
}

public extension RoadConditions {
    var lineColor: Color {
        switch self {
        case .clear:
            return .clear
        case .partlyCovered:
            return .secondary
        case .mostlyCovered:
            return .gray
        case .covered:
            return .black
        }
    }
    
    var regionColor: Color { lineColor.opacity(0.2) }
    
    var view: some View {
        HStack {
            Rectangle()
                .fill(lineColor)
                .frame(width: 40, height: 20)
                .cornerRadius(2)
            Text(rawValue)
        }
    }
}
