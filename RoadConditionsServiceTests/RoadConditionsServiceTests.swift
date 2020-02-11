@testable import RoadConditionsService
import XCTest

final class RoadConditionsServiceTests: HttpMockingTestCase {
    
    private lazy var roadConditionsService = RoadConditionsService(sessionManager: mockSessionManager)

    func testWhenGetRoadConditionsThenAllSegmentsAreReturned() {
        let expectation = XCTestExpectation(description: "Get Road Conditions")
        stub(.get, "30453f682b104d33980397c86ef56126_0.geojson", fixture: "Midwest_Winter_Road_Conditions")
        stub(.get, "181770a5c1bf498797245c13afffa155_0.geojson", fixture: "Iowa_Winter_Road_Conditions")
        stub(.post, "eventMapFeatures/updateMap", fixture: "Indiana_Winter_Road_Conditions")
        
        roadConditionsService.getRoadConditions { result in
            defer { expectation.fulfill() }
            guard case let .success(roadConditionSegments) = result else {
                XCTFail("Unexpected Failure")
                return
            }
            
            XCTAssertEqual(roadConditionSegments.count, 2)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
