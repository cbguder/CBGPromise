import Quick
import Nimble
import CBGPromise

class PromiseSpec: QuickSpec {
    override func spec() {
        describe("Promise") {
            var subject: Promise<String>!

            beforeEach {
                subject = Promise<String>()
            }

            describe("calling the callback blocks") {
                var result: String!

                context("when the callbacks are registered before the promise is resolved") {
                    beforeEach {
                        _ = subject.future.then { r in
                            result = r
                        }
                    }

                    it("should call the callback when it's resolved") {
                        subject.resolve("My Special Value")

                        expect(result).to(equal("My Special Value"))
                    }
                }

                context("when the callbacks are registered after the promise is resolved") {
                    it("should call the callback when it's resolved") {
                        subject.resolve("My Special Value")

                        _ = subject.future.then { r in
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

                    _ = subject.future.then { v in valA = v }
                    _ = subject.future.then { v in valB = v }

                    subject.resolve("My Special Value")

                    expect(valA).to(equal("My Special Value"))
                    expect(valB).to(equal("My Special Value"))
                }
            }

            describe("multiple resolving") {
                context("resolving after having been resolved already") {
                    beforeEach {
                        subject.resolve("old")
                    }

                    it("raises an exception") {
                        expect { subject.resolve("new") }.to(raiseException())
                    }
                }
            }

            describe("mapping") {
                it("returns a new future") {
                    var mappedValue: Int?

                    let mappedFuture = subject.future.map { str -> Int? in
                        return Int(str)
                    }

                    _ = mappedFuture.then { num in
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

                    _ = mappedFuture.then { num in
                        mappedValue = num
                    }

                    subject.resolve("Irrelevant")
                    mappedPromise.resolve(123)

                    expect(mappedValue).to(equal(123))
                }
            }
        }
    }
}
