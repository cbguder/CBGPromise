// If you need to handle error cases, such as when making network calls,
// the recommended approach is to use enum types:

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

class ErrorsExample {
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
