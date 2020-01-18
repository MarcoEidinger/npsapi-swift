import XCTest
@testable import npsapi_swift

final class npsapi_swiftTests: XCTestCase {

    func testFetchParks() {
        if #available(iOS 13.1, *) {
            let api = NationalParkServiceApiForSwift(apiKey: "cxJhOzdPDG85b4HNpAbo932GsV7st7kPUQXNnd4W")
            let expectation = XCTestExpectation(description: "Download Parks")
            let publisher = api.fetchParks(by: ["acad"])
            let subscription = publisher.sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    print(error)
                    XCTFail()
                }
            }) { (parks) in
                XCTAssertTrue(parks.count > 0, "We have parks")
                guard let firstState = parks.first?.states.first else {
                    XCTFail("No state")
                    return
                }
                XCTAssertTrue(firstState == .maine, "We have a state")
            }
            XCTAssertNotNil(subscription)
            XCTAssertNotNil(subscription)
            wait(for: [expectation], timeout: 30.0)
        } else {
            XCTFail()
        }
    }

    static var allTests = [
        ("testFetchParks", testFetchParks),
    ]
}
