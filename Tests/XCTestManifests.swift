import XCTest

extension PromiseTests {
    static let __allTests = [
        ("testCallbackBlockRegisteredAfterResolution", testCallbackBlockRegisteredAfterResolution),
        ("testCallbackBlockRegisteredBeforeResolution", testCallbackBlockRegisteredBeforeResolution),
        ("testMapAllowsChaining", testMapAllowsChaining),
        ("testMapReturnsNewFuture", testMapReturnsNewFuture),
        ("testMultipleCallbacks", testMultipleCallbacks),
        ("testValueAccessAfterResolution", testValueAccessAfterResolution),
        ("testWaitingForResolution", testWaitingForResolution),
        ("testWhenPreservesOrder", testWhenPreservesOrder),
        ("testWhenWaitsUntilResolution", testWhenWaitsUntilResolution),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PromiseTests.__allTests),
    ]
}
#endif
