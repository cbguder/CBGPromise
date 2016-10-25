import Foundation

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

    public func then(callback: @escaping (T) -> Void) -> Future<T> {
        callbacks.append(callback)

        if let value = value {
            callback(value)
        }

        return self
    }

    public func wait() -> T? {
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return self.value
    }

    public func map<U>(_ transform: @escaping (T) -> U) -> Future<U> {
        let mappedPromise = Promise<U>()

        _ = then { value in
            let mappedValue = transform(value)
            mappedPromise.resolve(mappedValue)
        }

        return mappedPromise.future
    }

    public func map<U>(_ transform: @escaping (T) -> Future<U>) -> Future<U> {
        let mappedPromise = Promise<U>()

        _ = then { value in
            let mappedFuture = transform(value)

            _ = mappedFuture.then { mappedValue in
                mappedPromise.resolve(mappedValue)
            }
        }

        return mappedPromise.future
    }

    func resolve(_ value: T) {
        precondition(!completed, "future is already resolved")

        completed = true

        self.value = value

        for callback in callbacks {
            callback(value)
        }

        semaphore.signal()
    }
}
