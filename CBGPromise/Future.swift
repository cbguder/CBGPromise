import Foundation

public class Future<T> {
    var successCallbacks: [(T) -> ()]
    var errorCallbacks: [(ErrorType) -> ()]

    public var value: T?
    public var error: ErrorType?

    let semaphore: dispatch_semaphore_t

    init() {
        semaphore = dispatch_semaphore_create(0)
        successCallbacks = []
        errorCallbacks = []
    }

    public func then(callback: (T) -> ()) -> Future<T> {
        successCallbacks.append(callback)

        if let value = value {
            callback(value)
        }
        
        return self
    }

    public func error(callback: (ErrorType) -> ()) -> Future<T> {
        errorCallbacks.append(callback)

        if let error = error {
            callback(error)
        }

        return self
    }

    public func wait() {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    func resolve(value: T) {
        self.value = value

        for successCallback in successCallbacks {
            successCallback(value)
        }

        dispatch_semaphore_signal(semaphore)
    }

    func reject(error: ErrorType) {
        self.error = error

        for errorCallback in errorCallbacks {
            errorCallback(error)
        }

        dispatch_semaphore_signal(semaphore)
    }
}
