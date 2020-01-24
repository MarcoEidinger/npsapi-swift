#if !canImport(ObjectiveC)
import XCTest

extension NationalParkServiceApiTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__NationalParkServiceApiTests = [
        ("testErrorHandlingInvalidApiKey", testErrorHandlingInvalidApiKey),
        ("testFetchAlertsByParkCode", testFetchAlertsByParkCode),
        ("testFetchAssetsByParkCode", testFetchAssetsByParkCode),
        ("testFetchNewsReleaseByParkCode", testFetchNewsReleaseByParkCode),
        ("testFetchParkByParkCode", testFetchParkByParkCode),
        ("testFetchParksByState", testFetchParksByState),
        ("testFetchParksWithRequestOption", testFetchParksWithRequestOption),
        ("testFetchParkWithNoResult", testFetchParkWithNoResult),
        ("testFetchVisitorCentersByParkCode", testFetchVisitorCentersByParkCode),
    ]
}

extension StateInUSATests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StateInUSATests = [
        ("testAbbreviation", testAbbreviation),
        ("testCompleteness", testCompleteness),
        ("testName", testName),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NationalParkServiceApiTests.__allTests__NationalParkServiceApiTests),
        testCase(StateInUSATests.__allTests__StateInUSATests),
    ]
}
#endif
