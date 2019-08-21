import Foundation

public final class Promise<T> {
    public let future: Future<T>

    public init() {
        future = Future<T>()
    }

    public func resolve(on: DispatchQueue = .main, _ value: T) {
        future.resolve(on: on, value)
    }

    @discardableResult
    public class func when<T>(on: DispatchQueue = .main, _ futures: [Future<T>]) -> Future<[T]> {
        let promise = Promise<[T]>()
        var values: [T?] = futures.map { _ in nil }

        var currentCount = 0

        for (idx, future) in futures.enumerated() {
            future.then(on: on) {
                values[idx] = $0
                currentCount += 1
                if currentCount == futures.count {
                    promise.resolve(on: on, values.map { $0! })
                }
            }
        }
        return promise.future
    }
}
