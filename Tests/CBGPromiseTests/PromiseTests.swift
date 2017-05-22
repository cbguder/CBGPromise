import Quick
import Nimble
import Dispatch
import CBGPromise

class PromiseTests: QuickSpec {
    override func spec() {
        describe("Promise") {
            var subject: Promise<String>!

            beforeEach {
                subject = Promise<String>()
            }

            describe("calling the callback blocks") {
                var result: String!

                context("when the callbacks are registered before the promise is resolved") {
                    it("should call the callback when it's resolved") {
                        subject.future.then { r in
                            result = r
                        }

                        subject.resolve("My Special Value")

                        expect(result).to(equal("My Special Value"))
                    }
                }

                context("when the callbacks are registered after the promise is resolved") {
                    it("should call the callback when it's resolved") {
                        subject.resolve("My Special Value")

                        subject.future.then { r in
                            result = r
                        }

                        expect(result).to(equal("My Special Value"))
                    }
                }
            }

            describe("accessing the value after the promise has been resolved") {
                it("should expose its value after it has been resolved") {
                    subject.resolve("My Special Value")

                    expect(subject.future.value).to(equal("My Special Value"))
                }
            }

            describe("waiting for the promise to resolve") {
                it("should wait for a value") {
                    let queue = DispatchQueue(label: "test")

                    queue.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                        subject.resolve("My Special Value")
                    }

                    let receivedValue = subject.future.wait()

                    expect(subject.future.value).to(equal("My Special Value"))
                    expect(receivedValue).to(equal(subject.future.value))
                }
            }

            describe("multiple callbacks") {
                it("calls each callback when the promise is resolved") {
                    var valA: String?
                    var valB: String?

                    subject.future.then { v in valA = v }
                    subject.future.then { v in valB = v }

                    subject.resolve("My Special Value")

                    expect(valA).to(equal("My Special Value"))
                    expect(valB).to(equal("My Special Value"))
                }
            }

#if !SWIFT_PACKAGE
// see https://github.com/Quick/Nimble/blob/master/Sources/Nimble/Matchers/ThrowAssertion.swift
            describe("multiple resolving") {
                context("resolving after having been resolved already") {
                    it("raises an exception") {
                        subject.resolve("old")

                        expect { subject.resolve("new") }.to(throwAssertion())
                    }
                }
            }
#endif

            describe("mapping") {
                it("returns a new future") {
                    var mappedValue: Int?

                    let mappedFuture = subject.future.map { str -> Int? in
                        return Int(str)
                    }

                    mappedFuture.then { num in
                        mappedValue = num
                    }

                    subject.resolve("123")

                    expect(mappedValue).to(equal(123))
                }

                it("allows promise chaining") {
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

                    expect(mappedValue).to(equal(123))
                }
            }

            describe("cancelling") {
                var result: String!

                context("when the callbacks are registered before the promise is resolved") {
                    it("should not call the callback when it's resolved") {
                        subject.cancel()
                        subject.future.then { r in
                            result = r
                        }

                        subject.resolve("My Special Value")

                        expect(result).to(beNil())
                    }
                }

                context("when the callbacks are registered after the promise is resolved") {
                    it("should not call the callback when it's resolved") {
                        subject.cancel()
                        subject.resolve("My Special Value")

                        subject.future.then { r in
                            result = r
                        }

                        expect(result).to(beNil())
                    }
                }
            }

            describe("when") {
                var firstPromise: Promise<String>!
                var secondPromise: Promise<String>!

                var receivedFuture: Future<[String]>!

                beforeEach {
                    firstPromise = Promise<String>()
                    secondPromise = Promise<String>()

                    receivedFuture = Promise<String>.when([firstPromise.future, secondPromise.future])
                }

                it("waits until both promises resolve to return") {
                    expect(receivedFuture.value).to(beNil())
                    firstPromise.resolve("hello")
                    expect(receivedFuture.value).to(beNil())
                    secondPromise.resolve("goodbye")
                    expect(receivedFuture.value) == ["hello", "goodbye"]
                }

                it("returns the array in the order the promises were given") {
                    secondPromise.resolve("goodbye")
                    firstPromise.resolve("hello")
                    expect(receivedFuture.value) == ["hello", "goodbye"]
                }
            }
        }
    }
}
