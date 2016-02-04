import Foundation

public class Promise<T> {
    public let future: Future<T>

    public init() {
        future = Future<T>()
    }

    public func resolve(value: T) {
        future.resolve(value)
    }
}
