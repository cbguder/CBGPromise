import Quick
import Nimble
import CBGPromise

class PromiseSpec: QuickSpec {
    override func spec() {
        describe("Promise") {
            var subject: Promise<String>!
            var value: String?
            var error: NSError?

            beforeEach {
                subject = Promise<String>()

                value = nil
                error = nil
            }

            context("when the callbacks are registered before the promise is resolved/rejected") {
                beforeEach {
                    subject.future.then { v in
                        value = v
                    }

                    subject.future.error { e in
                        error = e
                    }
                }

                it("should resolve its future") {
                    subject.resolve("My Special Value")

                    expect(value).to(equal("My Special Value"))
                }

                it("should reject its future") {
                    let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                    subject.reject(expectedError)

                    expect(error).to(equal(expectedError))
                }
            }

            context("when the callbacks are registered after the promise is resolved/rejected") {
                it("should resolve its future") {
                    subject.resolve("My Special Value")

                    subject.future.then { v in
                        value = v
                    }

                    expect(value).to(equal("My Special Value"))
                }

                it("should reject its future") {
                    let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                    subject.reject(expectedError)

                    subject.future.error { e in
                        error = e
                    }

                    expect(error).to(equal(expectedError))
                }
            }
        }
    }
}
