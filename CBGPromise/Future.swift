import Foundation

public class Future<T> {
    var successCallback: ((T) -> ())?
    var errorCallback: ((NSError) -> ())?

    public func then(callback: (T) -> ()) {
        successCallback = callback
    }

    public func error(callback: (NSError) -> ()) {
        errorCallback = callback
    }

    func resolve(value: T) {
        if let successCallback = successCallback {
            successCallback(value)
        }
    }

    func reject(error: NSError) {
        if let errorCallback = errorCallback {
            errorCallback(error)
        }
    }
}
