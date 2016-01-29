import Foundation

public class Future<T, ET: ErrorType> {
    var successCallbacks: [(T) -> ()]
    var errorCallbacks: [(ET) -> ()]

    private var completed: Bool

    public var value: T?
    public var error: ET?

    let semaphore: dispatch_semaphore_t

    init() {
        semaphore = dispatch_semaphore_create(0)
        successCallbacks = []
        errorCallbacks = []
        completed = false
    }

    public func then(callback: (T) -> ()) -> Future<T, ET> {
        successCallbacks.append(callback)

        if let value = value {
            callback(value)
        }
        
        return self
    }

    public func error(callback: (ET) -> ()) -> Future<T, ET> {
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
        guard !completed else { preconditionFailed("resolve"); return }

        self.complete()
        self.value = value

        for successCallback in successCallbacks {
            successCallback(value)
        }

        dispatch_semaphore_signal(semaphore)
    }

    func reject(error: ET) {
        guard !completed else { preconditionFailed("reject"); return }

        self.complete()
        self.error = error

        for errorCallback in errorCallbacks {
            errorCallback(error)
        }

        dispatch_semaphore_signal(semaphore)
    }

    private func complete() {
        self.completed = true
    }
    
    private func preconditionFailed(call: String) {
        NSException(name: "invalid \(call)", reason: "already resolved / rejected", userInfo: nil).raise()
    }
}
