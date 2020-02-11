import Foundation
import MapKit
@testable import RoadConditionsService

enum FixtureHelper {
    static private func jsonData(for localFileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: localFileName, ofType: "json") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
