import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(npsapi_swiftTests.allTests),
    ]
}
#endif
