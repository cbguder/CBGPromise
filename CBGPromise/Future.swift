import Foundation

public class Future<T> {
    var callbacks: [(T) -> ()]

    private var completed: Bool

    public var value: T?

    let semaphore: dispatch_semaphore_t

    init() {
        semaphore = dispatch_semaphore_create(0)
        callbacks = []
        completed = false
    }

    public func then(callback: (T) -> ()) -> Future<T> {
        callbacks.append(callback)

        if let value = value {
            callback(value)
        }

        return self
    }

    public func wait() {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    func resolve(value: T) {
        guard !completed else {
            NSException(name: "invalid resolution", reason: "already resolved", userInfo: nil).raise()
            return
        }

        completed = true

        self.value = value

        for callback in callbacks {
            callback(value)
        }

        dispatch_semaphore_signal(semaphore)
    }
}
