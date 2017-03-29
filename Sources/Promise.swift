import Foundation

public final class Promise<T> {
    public let future: Future<T>

    public init() {
        future = Future<T>()
    }

    public func resolve(_ value: T) {
        future.resolve(value)
    }

    @discardableResult
    public class func when<T>(_ futures: [Future<T>]) -> Future<[T]> {
        let promise = Promise<[T]>()
        var values: [T?] = futures.map { _ in nil }

        var currentCount = 0

        for (idx, future) in futures.enumerated() {
            future.then {
                values[idx] = $0
                currentCount += 1
                if currentCount == futures.count {
                    promise.resolve(values.map { $0! })
                }
            }
        }
        return promise.future
    }
}
