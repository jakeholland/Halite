@testable import RoadConditionsService
import XCTest

final class RoadConditionsServiceTests: XCTestCase {
    
    private let mockRoadConditionsService = MockRoadConditionsService()

    func testWhenGetRoadConditionsThenErrorIsReturned() {
        let mockError = MockError()
        mockRoadConditionsService.errorToReturn = mockError
        mockRoadConditionsService.getRoadConditions(in: .mock) { result in
            guard case let .failure(error) = result else {
                XCTFail("Unexpected Success")
                return
            }
            
            XCTAssertEqual(error as? MockError, mockError)
        }
    }
    
    func testWhenGetRoadConditionsThenConditionsAreReturned() {
        let mockRoadConditions: [MockRoadConditionsMultiPolyline] = .mock
        mockRoadConditionsService.conditionsToReturn = mockRoadConditions
        mockRoadConditionsService.getRoadConditions(in: .mock) { result in
            guard case let .success(roadConditions) = result else {
                XCTFail("Unexpected Failure")
                return
            }
            
            XCTAssertEqual(roadConditions, mockRoadConditions)
        }
    }
}
