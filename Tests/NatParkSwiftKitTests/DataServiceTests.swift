import XCTest
@testable import NatParkSwiftKit

final class DataServiceTests: XCTestCase {

    private var api: DataService! = nil

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

        self.api = DataService(apiKey: testKey)
    }

    func testErrorHandlingInvalidApiKey() {
        self.api = DataService(apiKey: "InvalidKey")
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: [ParkCodeConstants.acadia])
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                XCTFail("subscription finished unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error, "We should have an error object")
                expectation.fulfill()
            }
        }) { (parks) in
            XCTFail("We recevied data unexpectedly")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParkWithNoResult() {
        let expectation = XCTestExpectation(description: "Will not find park")
        let publisher = api.fetchPark("DOES_NOT_EXIST")
        let subscription = publisher
            .replaceError(with: nil)
            .sink { (park) in
                XCTAssertNil(park, "No park should have been found for that key")
                expectation.fulfill()
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParkByParkCode() {
        let expectation = XCTestExpectation(description: "Download specific park")
        let publisher = api.fetchPark(ParkCodeConstants.acadia)
        let subscription = publisher
            .replaceError(with: nil)
            .sink { (park) in
                guard let park = park else {
                    XCTFail("No park information found")
                    return
                }
                guard let firstState = park.states.first else {
                    XCTFail("No state")
                    return
                }
                XCTAssertTrue(firstState == .maine, "We have a state")
                XCTAssertNotNil(park.url, "Park has to have url")
                XCTAssertNotNil(park.gpsLocation, "Park has to have gps coordinates")
                XCTAssertNil(park.entranceFees, "We should not have receive a non default field without requesting it")
                XCTAssertNil(park.entrancePasses, "We should not have receive a non default field without requesting it")
                expectation.fulfill()
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParksByState() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: nil, in: [.california], nil)
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (parks, totalCount) = resultTuple
            XCTAssertTrue(totalCount > 0, "We have parks")
            XCTAssertTrue(parks.count > 0, "We have parks")
            XCTAssertEqual(totalCount, parks.count, "Shall be same in this case as parks in california are less than default paging (50)")
            guard let firstState = parks.first?.states.first else {
                XCTFail("No state")
                return
            }
            XCTAssertTrue(firstState == .california, "We have a state")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchParksWithRequestOption() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: nil, in: [.california], RequestOptions.init(limit: 5, searchQuery: "Yosemite National Park", fields: [.images, .entranceFees, .entrancePasses, .addresses]))
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (parks, totalCount) = resultTuple
            XCTAssertEqual(totalCount, 1, "We have parks")
            XCTAssertEqual(parks.count, 1, "We have parks")
            XCTAssertEqual(parks.first?.parkCode, ParkCodeConstants.yosemite)
            XCTAssertNotNil(parks.first?.images, "We should have images")
            XCTAssertNotNil(parks.first?.images?.first?.url, "We should have image url")
            XCTAssertNotNil(parks.first?.entranceFees, "We should not have receive a non default field without requesting it")
            XCTAssertNotNil(parks.first?.entrancePasses, "We should not have receive a non default field without requesting it")
            XCTAssertNotNil(parks.first?.addresses, "We should not have receive a non default field without requesting it")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }
    func testFetchParksWithPagination() {
        let expectation = XCTestExpectation(description: "Download Parks")
        let publisher = api.fetchParks(by: nil, in: nil, RequestOptions.init(limit: 20, start: 2, searchQuery: nil, fields: nil))
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (parks, totalCount) = resultTuple
            XCTAssertGreaterThanOrEqual(totalCount, 497, "There are currently 497 parks in NPS")
            XCTAssertEqual(parks.count, 20, "Only 20 were fetched from server")
            XCTAssertEqual(parks.first?.parkCode, "bepa", "Not avia but bepa is first park due to the start parameter")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchAlertsByParkCode() {
        let expectation = XCTestExpectation(description: "Download Alerts")
        let publisher = api.fetchAlerts(by: [ParkCodeConstants.acadia])
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (alerts, _) = resultTuple
            XCTAssertTrue(alerts.count > 0, "We have alerts")
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchNewsReleaseByParkCode() {
        let expectation = XCTestExpectation(description: "Download NewsReleases")
        let publisher = api.fetchNewsReleases()
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (alerts, _) = resultTuple
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

    func testFetchVisitorCentersByParkCode() {
        let expectation = XCTestExpectation(description: "Download Visitor Centers")
        let publisher = api.fetchVisitorCenters(by: [ParkCodeConstants.yellowstone], in: nil, RequestOptions.init(searchQuery: nil, fields: [.addresses, .operatingHours]))
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (visitorCenters, _) = resultTuple
            XCTAssertTrue(visitorCenters.count > 0, "We have visitor centers")
            XCTAssertNotNil(visitorCenters.first?.id)
            XCTAssertNotNil(visitorCenters.first?.name)
            XCTAssertNotNil(visitorCenters.first?.description)
            XCTAssertNotNil(visitorCenters.first?.parkCode)
            XCTAssertNotNil(visitorCenters.first?.directionsInfo)
            XCTAssertNotNil(visitorCenters.first?.gpsLocation)
            XCTAssertNotNil(visitorCenters.first?.addresses)
            XCTAssertEqual(visitorCenters.first?.addresses?.first?.stateCode, StateInUSA.wyoming)
            XCTAssertNotNil(visitorCenters.first?.operatingHours)
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }

    func testFetchAssetsByParkCode() {
        let expectation = XCTestExpectation(description: "Download Assets")
        let publisher = api.fetchAssets(by: [ParkCodeConstants.yellowstone], in: nil, nil)
        let subscription = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("subscription returned error unexpectedly")
            }
        }) { (resultTuple) in
            let (assets, _) = resultTuple
            XCTAssertTrue(assets.count > 0, "We have assets / places")
            XCTAssertNotNil(assets.first?.id)
            XCTAssertNotNil(assets.first?.listingImage.url)
            XCTAssertNotNil(assets.first?.listingImage.altText)
        }
        XCTAssertNotNil(subscription)
        wait(for: [expectation], timeout: 45.0)
    }
}
