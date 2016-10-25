// You can wait for a promise to resolve using the wait() function

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

class WaitingExample {
    func main() {
        let client = Client()

        let future = client.getValue()

        _ = future.then { value in
            print(value)
        }

        _ = future.wait()
    }
}
