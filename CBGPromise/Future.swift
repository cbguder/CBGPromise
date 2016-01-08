import Foundation

public class Future<T> {
    var successCallback: ((T) -> ())?
    var errorCallback: ((ErrorType) -> ())?

    public var value: T?
    public var error: ErrorType?

    let semaphore: dispatch_semaphore_t

    init() {
        semaphore = dispatch_semaphore_create(0)
    }

    public func then(callback: (T) -> ()) {
        successCallback = callback

        if let value = value {
            callback(value)
        }
    }

    public func error(callback: (ErrorType) -> ()) {
        errorCallback = callback

        if let error = error {
            callback(error)
        }
    }

    public func wait() {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    func resolve(value: T) {
        self.value = value

        if let successCallback = successCallback {
            successCallback(value)
        }

        dispatch_semaphore_signal(semaphore)
    }

    func reject(error: ErrorType) {
        self.error = error

        if let errorCallback = errorCallback {
            errorCallback(error)
        }

        dispatch_semaphore_signal(semaphore)
    }
}
