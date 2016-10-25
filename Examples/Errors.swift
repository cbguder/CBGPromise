// If you need to handle error cases, such as when making network calls,
// the recommended approach is to use enum types:

import CBGPromise

enum NetworkResult {
    case Success(Data)
    case Error(Error)
}

class NetworkClient {
    let session: URLSession!

    init(session: URLSession) {
        self.session = session
    }

    func sendRequest(_ request: URLRequest) -> Future<NetworkResult> {
        let promise = Promise<NetworkResult>()

        let task = session.dataTask(with: request) { (data, response, error) in
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
        let session = URLSession.shared
        let client = NetworkClient(session: session)

        let url = URL(string: "https://www.example.com")!
        let request = URLRequest(url: url as URL)

        let future = client.sendRequest(request)

        _ = future.then { networkResult in
            switch networkResult {
            case .Success(let data):
                print(data)
            case .Error(let error):
                print(error)
            }
        }
    }
}
