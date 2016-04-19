# CBGPromise

[![CI Status](https://img.shields.io/circleci/project/cbguder/CBGPromise/master.svg)](https://circleci.com/gh/cbguder/CBGPromise/tree/master)
[![Version](https://img.shields.io/cocoapods/v/CBGPromise.svg?style=flat)](http://cocoapods.org/pods/CBGPromise)
[![License](https://img.shields.io/cocoapods/l/CBGPromise.svg?style=flat)](http://cocoapods.org/pods/CBGPromise)
[![Platform](https://img.shields.io/cocoapods/p/CBGPromise.svg?style=flat)](http://cocoapods.org/pods/CBGPromise)

## Installation

CBGPromise is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "CBGPromise"
```

## Usage

A simple example might look like this:

```swift
import CBGPromise

class Client {
    func getValue() -> Future<String> {
        let promise = Promise<String>()

        someAsyncCall {
            promise.resolve("Test")
        }

        return promise.future
    }
}

class SimpleExample {
    func main() {
        let client = Client()

        client.getValue().then { value in
            print(value)
        }
    }
}
```

If you need to handle error cases, such as when making network calls, the recommended approach is to use enum types:

```swift
import CBGPromise

enum NetworkResult {
    case Success(NSData)
    case Error(NSError)
}

class NetworkClient {
    let session: NSURLSession!

    init(session: NSURLSession) {
        self.session = session
    }

    func sendRequest(request: NSURLRequest) -> Future<NetworkResult> {
        let promise = Promise<NetworkResult>()

        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                promise.resolve(.Error(error))
            }

            if let data = data {
                promise.resolve(.Success(data))
            }
        }

        task.resume()

        return promise.future
    }
}

class NetworkExample {
    func main() {
        let session = NSURLSession.sharedSession()
        let client = NetworkClient(session: session)

        let url = NSURL(string: "https://www.example.com")!
        let request = NSURLRequest(URL: url)

        let future = client.sendRequest(request)

        future.then { networkResult in
            switch networkResult {
            case .Success(let data):
                print(data)
            case .Error(let error):
                print(error)
            }
        }
    }
}
```

## Author

Can Berk Güder

## License

CBGPromise is available under the MIT license. See the LICENSE file for more info.
