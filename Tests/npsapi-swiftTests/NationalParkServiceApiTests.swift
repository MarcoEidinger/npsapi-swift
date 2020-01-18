import XCTest
@testable import npsapi_swift

final class NationalParkServiceApiTests: XCTestCase {

    func testFetchParks() {
        if #available(iOS 13.1, *) {
            guard let data = Data(base64Encoded: "Y3hKaE96ZFBERzg1YjRITnBBYm85MzJHc1Y3c3Q3a1BVUVhObmQ0Vw==") else {
                XCTFail("invalid api key for testing")
                return
            }
            guard let testKey = String(data: data, encoding: .utf8) else {
                XCTFail("invalid api key for testing")
                return
            }
            let api = NationalParkServiceApi(apiKey: testKey)
            let expectation = XCTestExpectation(description: "Download Parks")
            let publisher = api.fetchParks(by: ["acad"])
            let subscription = publisher.sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    print(error)
                    XCTFail("subscription returned error unexpectedly")
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
            wait(for: [expectation], timeout: 45.0)
        } else {
            XCTFail("not supported version")
        }
    }

    static var allTests = [
        ("testFetchParks", testFetchParks)
    ]
}
