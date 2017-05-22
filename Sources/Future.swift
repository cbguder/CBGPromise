import Foundation
import Dispatch

public final class Future<T> {
    private var callbacks: [(T) -> Void]

    private var completed: Bool
    private var cancelled: Bool

    public private(set) var value: T?

    let semaphore: DispatchSemaphore

    init() {
        semaphore = DispatchSemaphore(value: 0)
        callbacks = []
        completed = false
        cancelled = false
    }

    @discardableResult
    public func then(callback: @escaping (T) -> Void) -> Future<T> {
        callbacks.append(callback)

        if !cancelled {
            if let value = value {
                callback(value)
            }
        }

        return self
    }

    @discardableResult
    public func wait() -> T? {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return self.value
    }

    @discardableResult
    public func map<U>(_ transform: @escaping (T) -> U) -> Future<U> {
        let mappedPromise = Promise<U>()

        then { value in
            let mappedValue = transform(value)
            mappedPromise.resolve(mappedValue)
        }

        return mappedPromise.future
    }

    @discardableResult
    public func map<U>(_ transform: @escaping (T) -> Future<U>) -> Future<U> {
        let mappedPromise = Promise<U>()

        then { value in
            let mappedFuture = transform(value)

            mappedFuture.then { mappedValue in
                mappedPromise.resolve(mappedValue)
            }
        }

        return mappedPromise.future
    }

    func resolve(_ value: T) {
        precondition(!completed, "future is already resolved")

        if cancelled {
            semaphore.signal()
            return
        }

        completed = true

        self.value = value

        for callback in callbacks {
            callback(value)
        }

        semaphore.signal()
    }

    func cancel() {
        self.cancelled = true
    }
}
