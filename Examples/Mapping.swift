// You can map and chain promises using the map() and futureMap() functions:

import CBGPromise

class Client {
    func getIntegerValue() -> Future<Int> {
        let promise = Promise<Int>()

        otherAsyncCall {
            promise.resolve(42)
        }

        return promise.future
    }

    func getArrayValue(int: Int) -> Future<[String]> {
        let promise = Promise<[String]>()

        someAsyncCall(int) {
            promise.resolve(["Test 1", "Test 2"])
        }

        return promise.future
    }
}

class MappingExample {
    func main() {
        let client = Client()

        let integerFuture = client.getIntegerValue()

        let arrayFuture = integerFuture.futureMap { int -> Future<[String]> in
            return client.getArrayValue(int)
        }

        let stringFuture = arrayFuture.map { arr -> String? in
            return arr.first
        }

        stringFuture.then { value in
            print(value)
        }
    }
}
