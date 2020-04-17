import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ironoxide_swiftTests.allTests),
    ]
}
#endif
