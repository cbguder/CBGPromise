import Dispatch
import XCTest
import CBGPromise

class PromiseTests: XCTestCase {

    var subject: Promise<String>!

    override func setUp() {
        subject = Promise<String>()
    }

    func testCallbackBlockRegisteredBeforeResolution() {
        var result: String!

        subject.future.then { r in
            result = r
        }

        subject.resolve("My Special Value")

        XCTAssertEqual(result, "My Special Value")
    }

    func testCallbackBlockRegisteredAfterResolution() {
        var result: String!

        subject.resolve("My Special Value")

        subject.future.then { r in
            result = r
        }

        XCTAssertEqual(result, "My Special Value")
    }

    func testValueAccessAfterResolution() {
        subject.resolve("My Special Value")

        XCTAssertEqual(subject.future.value, "My Special Value")
    }

    func testWaitingForResolution() {
        let queue = DispatchQueue(label: "test")

        queue.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.subject.resolve("My Special Value")
        }

        let receivedValue = subject.future.wait()

        XCTAssertEqual(subject.future.value, "My Special Value")
        XCTAssertEqual(receivedValue, subject.future.value)
    }

    func testMultipleCallbacks() {
        var valA: String?
        var valB: String?

        subject.future.then { v in valA = v }
        subject.future.then { v in valB = v }

        subject.resolve("My Special Value")

        XCTAssertEqual(valA, "My Special Value")
        XCTAssertEqual(valB, "My Special Value")
    }

    func testMapReturnsNewFuture() {
        var mappedValue: Int?

        let mappedFuture = subject.future.map { str -> Int? in
            return Int(str)
        }

        mappedFuture.then { num in
            mappedValue = num
        }

        subject.resolve("123")

        XCTAssertEqual(mappedValue, 123)
    }

    func testMapAllowsChaining() {
        var mappedValue: Int?

        let mappedPromise = Promise<Int>()

        let mappedFuture = subject.future.map { str -> Future<Int> in
            return mappedPromise.future
        }

        mappedFuture.then { num in
            mappedValue = num
        }

        subject.resolve("Irrelevant")
        mappedPromise.resolve(123)

        XCTAssertEqual(mappedValue, 123)
    }

    func testWhenWaitsUntilResolution() {
        let firstPromise = Promise<String>()
        let secondPromise = Promise<String>()

        let receivedFuture = Promise<String>.when([firstPromise.future, secondPromise.future])
        XCTAssertNil(receivedFuture.value)

        firstPromise.resolve("hello")
        XCTAssertNil(receivedFuture.value)

        secondPromise.resolve("goodbye")
        XCTAssertEqual(receivedFuture.value, ["hello", "goodbye"])
    }

    func testWhenPreservesOrder() {
        let firstPromise = Promise<String>()
        let secondPromise = Promise<String>()

        let receivedFuture = Promise<String>.when([firstPromise.future, secondPromise.future])

        secondPromise.resolve("goodbye")
        firstPromise.resolve("hello")
        XCTAssertEqual(receivedFuture.value, ["hello", "goodbye"])
    }

}
