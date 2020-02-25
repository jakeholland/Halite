@testable import RoadConditionsService
import CoreLocation
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
            
            XCTAssertEqual(roadConditionSegments[0].roadConditions, RoadConditions.clear)
            XCTAssertEqual(roadConditionSegments[0].polylines.count, 7332)
            let firstClearPolylineCoordinate = roadConditionSegments[0].polylines[0].coordinate
            XCTAssertEqual(firstClearPolylineCoordinate.latitude, 37.592, accuracy: 0.001)
            XCTAssertEqual(firstClearPolylineCoordinate.longitude, -92.137, accuracy: 0.001)
            
            XCTAssertEqual(roadConditionSegments[1].roadConditions, RoadConditions.partlyCovered)
            XCTAssertEqual(roadConditionSegments[1].polylines.count, 38)
            let firstPartlyCoveredPolylineCoordinate = roadConditionSegments[1].polylines[0].coordinate
            XCTAssertEqual(firstPartlyCoveredPolylineCoordinate.latitude, 42.396, accuracy: 0.001)
            XCTAssertEqual(firstPartlyCoveredPolylineCoordinate.longitude, -98.451, accuracy: 0.001)
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
