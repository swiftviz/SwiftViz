import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(SwiftVizTests.allTests),
        ]
    }
#endif
