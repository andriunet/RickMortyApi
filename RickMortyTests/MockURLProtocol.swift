import Foundation

class MockURLProtocol: URLProtocol {
    static var testData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let data = MockURLProtocol.testData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
