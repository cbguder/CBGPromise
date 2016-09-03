import Foundation

public final class Promise<T> {
    public let future: Future<T>

    public init() {
        future = Future<T>()
    }

    public func resolve(_ value: T) {
        future.resolve(value)
    }
}
