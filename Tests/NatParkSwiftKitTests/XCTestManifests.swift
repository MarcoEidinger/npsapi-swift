#if !canImport(ObjectiveC)
import XCTest

extension DataServiceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DataServiceTests = [
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

extension ParkTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParkTests = [
        ("testEqualityComparision", testEqualityComparision),
        ("testHashableConformance", testHashableConformance),
        ("testMemberwiseInitializer", testMemberwiseInitializer),
    ]
}

extension ParkUnitDesignationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParkUnitDesignationTests = [
        ("testAllCases", testAllCases),
        ("testInitFallbackToUnknown", testInitFallbackToUnknown),
        ("testValidInit", testValidInit),
    ]
}

extension StateInUSATests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StateInUSATests = [
        ("testAbbreviation", testAbbreviation),
        ("testCompleteness", testCompleteness),
        ("testDoubleName", testDoubleName),
        ("testSimpleName", testSimpleName),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataServiceTests.__allTests__DataServiceTests),
        testCase(ParkTests.__allTests__ParkTests),
        testCase(ParkUnitDesignationTests.__allTests__ParkUnitDesignationTests),
        testCase(StateInUSATests.__allTests__StateInUSATests),
    ]
}
#endif
