@testable import Halite
import XCTest

final class RoadConditionsViewModelTests: XCTestCase {
    private lazy var mockRoadConditionsService = MockRoadConditionsService()
    private lazy var viewModel = RoadConditionsViewModel(roadConditionsService: mockRoadConditionsService)
    
    func testWhenGetRoadConditionsThenConditionsAreReturned() {
        let mockRoadConditions: [MockRoadConditionsMultiPolyline] = .mock
        mockRoadConditionsService.conditionsToReturn = mockRoadConditions
        viewModel.loadRoadConditions()

        XCTAssertEqual(viewModel.roadConditionsSegments, mockRoadConditions)
    }
    
    func testWhenGetRoadConditionsThenErrorIsReturned() {
        let mockError = MockError()
        mockRoadConditionsService.errorToReturn = mockError
        viewModel.loadRoadConditions()
        
        XCTAssertEqual(viewModel.roadConditionsSegments.count, 0)
    }
}
