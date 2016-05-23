import Foundation

public class Future<T> {
    private var callbacks: [T -> Void]

    private var completed: Bool

    public var value: T?

    let semaphore: dispatch_semaphore_t

    init() {
        semaphore = dispatch_semaphore_create(0)
        callbacks = []
        completed = false
    }

    public func then(callback: T -> Void) -> Future<T> {
        callbacks.append(callback)

        if let value = value {
            callback(value)
        }

        return self
    }

    public func wait() -> T? {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return self.value
    }

    public func map<U>(transform: T -> U) -> Future<U> {
        let mappedPromise = Promise<U>()

        then { value in
            let mappedValue = transform(value)
            mappedPromise.resolve(mappedValue)
        }

        return mappedPromise.future
    }

    public func map<U>(transform: T -> Future<U>) -> Future<U> {
        let mappedPromise = Promise<U>()

        then { value in
            let mappedFuture = transform(value)

            mappedFuture.then { mappedValue in
                mappedPromise.resolve(mappedValue)
            }
        }

        return mappedPromise.future
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
