import Foundation

public class Future<T> {
    var successCallback: ((T) -> ())?
    var errorCallback: ((NSError) -> ())?

    public var value: T?
    public var error: NSError?

    public func then(callback: (T) -> ()) {
        successCallback = callback

        if let value = value {
            callback(value)
        }
    }

    public func error(callback: (NSError) -> ()) {
        errorCallback = callback

        if let error = error {
            callback(error)
        }
    }

    func resolve(value: T) {
        self.value = value

        if let successCallback = successCallback {
            successCallback(value)
        }
    }

    func reject(error: NSError) {
        self.error = error

        if let errorCallback = errorCallback {
            errorCallback(error)
        }
    }
}
