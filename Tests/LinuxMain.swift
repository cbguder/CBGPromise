import XCTest
import Quick

@testable import CBGPromiseTests

Quick.QCKMain([
        PromiseTests.self
    ],
    testCases: [
        testCase(PromiseTests.allTests)
    ]
)
