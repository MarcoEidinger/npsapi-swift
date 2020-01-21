import XCTest
@testable import npsapi_swift

final class NationalParkServiceApiTests: XCTestCase {

    private var api: NationalParkServiceApi! = nil

    override func setUp() {
        super.setUp()

        guard let data = Data(base64Encoded: "Y3hKaE96ZFBERzg1YjRITnBBYm85MzJHc1Y3c3Q3a1BVUVhObmQ0Vw==") else {
            XCTFail("invalid api key for testing")
            return
        }

        guard let testKey = String(data: data, encoding: .utf8) else {
            XCTFail("invalid api key for testing")
            return
        }

        self.api = NationalParkServiceApi(apiKey: testKey)
    }

    func testFetchParksByParkCode() {
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
            guard let firstState = parks.first?.states!.first else {
                XCTFail("No state")
                return
            }
            XCTAssertTrue(firstState == .maine, "We have a state")
            XCTAssertNotNil(parks.first?.url, "Park has to have url")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParksByState() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: nil, in: [.californa], nil)
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
            guard let firstState = parks.first?.states!.first else {
                XCTFail("No state")
                return
            }
            XCTAssertTrue(firstState == .californa, "We have a state")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParksWithRequestOption() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: nil, in: [.californa], RequestOptions.init(limit: 5, searchQuery: "Yosemite National Park", fields: [.designation]))
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (parks) in
            XCTAssertTrue(parks.count == 1, "We have parks")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchAlertsByParkCode() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchAlerts(by: ["acad"])
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (alerts) in
            XCTAssertTrue(alerts.count > 0, "We have alerts")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchNewsReleaseByParkCode() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchNewsReleases()
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (alerts) in
            XCTAssertTrue(alerts.count > 0, "We have news releaes")
            XCTAssertNotNil(alerts.first?.id)
            XCTAssertNotNil(alerts.first?.title)
            XCTAssertNotNil(alerts.first?.abstract)
            XCTAssertNotNil(alerts.first?.parkCode)
            XCTAssertNotNil(alerts.first?.releaseDate)
            XCTAssertNotNil(alerts.first?.url)
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    static var allTests = [
        ("testFetchParksByParkCode", testFetchParksByParkCode),
        ("testFetchParksByState", testFetchParksByState),
        ("testFetchParksWithRequestOption", testFetchParksWithRequestOption),
        ("testFetchAlertsByParkCode", testFetchAlertsByParkCode),
        ("testFetchNewsReleaseByParkCode", testFetchNewsReleaseByParkCode)
    ]
}
