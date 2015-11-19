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
                var value: String?
                var error: NSError?

                beforeEach {
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

                    it("should call the success callback when it's resolved") {
                        subject.resolve("My Special Value")

                        expect(value).to(equal("My Special Value"))
                    }

                    it("should call the error callback when it's rejected") {
                        let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                        subject.reject(expectedError)

                        expect(error).to(equal(expectedError))
                    }
                }

                context("when the callbacks are registered after the promise is resolved/rejected") {
                    it("should call the success callback when it's resolved") {
                        subject.resolve("My Special Value")

                        subject.future.then { v in
                            value = v
                        }

                        expect(value).to(equal("My Special Value"))
                    }

                    it("should call the error callback when it's rejected") {
                        let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                        subject.reject(expectedError)

                        subject.future.error { e in
                            error = e
                        }

                        expect(error).to(equal(expectedError))
                    }
                }
            }

            describe("accessing the value/error after the promise has been resolved/rejected") {
                it("should expose its value after it has been resolved") {
                    subject.resolve("My Special Value")

                    expect(subject.future.value).to(equal("My Special Value"))
                }

                it("should expose its error after it has been rejected") {
                    let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                    subject.reject(expectedError)

                    expect(subject.future.error).to(equal(expectedError))
                }
            }

            describe("waiting for the promise to resolve") {
                it("should wait for a value") {
                    let queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), queue) {
                        subject.resolve("My Special Value")
                    }

                    subject.future.wait()

                    expect(subject.future.value).to(equal("My Special Value"))
                }

                it("should wait for an error") {
                    let expectedError = NSError(domain: "My Special Domain", code: 123, userInfo: nil)

                    let queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), queue) {
                        subject.reject(expectedError)
                    }

                    subject.future.wait()

                    expect(subject.future.error).to(equal(expectedError))
                }
            }
        }
    }
}
