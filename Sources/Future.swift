import Foundation
import Dispatch

public final class Future<T> {
    private var callbacks: [(T) -> Void]

    private var completed: Bool

    public private(set) var value: T?

    let semaphore: DispatchSemaphore

    init() {
        semaphore = DispatchSemaphore(value: 0)
        callbacks = []
        completed = false
    }

    @discardableResult
    public func then(on: DispatchQueue = .main, callback: @escaping (T) -> Void) -> Future<T> {
        callbacks.append(callback)

        if let value = value {
            on.async {
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
    public func map<U>(on: DispatchQueue = .main, _ transform: @escaping (T) -> U) -> Future<U> {
        let mappedPromise = Promise<U>()

        then(on: on) { value in
            let mappedValue = transform(value)
            mappedPromise.resolve(on: on, mappedValue)
        }

        return mappedPromise.future
    }

    @discardableResult
    public func map<U>(on: DispatchQueue = .main, _ transform: @escaping (T) -> Future<U>) -> Future<U> {
        let mappedPromise = Promise<U>()

        then(on: on) { value in
            let mappedFuture = transform(value)

            mappedFuture.then(on: on) { mappedValue in
                mappedPromise.resolve(on: on, mappedValue)
            }
        }

        return mappedPromise.future
    }

    func resolve(on: DispatchQueue = .main, _ value: T) {
        precondition(!completed, "future is already resolved")

        completed = true

        self.value = value

        for callback in callbacks {
            on.async {
                callback(value)
            }
        }

        semaphore.signal()
    }
}
