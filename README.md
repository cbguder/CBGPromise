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

For other examples, see the [Examples](https://github.com/cbguder/CBGPromise/tree/master/Examples) folder.

## Author

Can Berk Güder

## License

CBGPromise is available under the MIT license. See the LICENSE file for more info.
