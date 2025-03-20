import Testing
import Foundation
@testable import Lumiform

@Suite(.serialized) class NetworkServiceTests {
    private var networkService: NetworkService!
    private var testURL: URL!
    
    init() {
        testURL = URL(string: "https://test.example.com")
    }
    
    @Test func fetchContent_InvalidURL_ThrowsError() async {
        networkService = NetworkService(contentURL: nil)
        
        await #expect(throws: NetworkError.invalidURL) {
            try await networkService.fetchContent()
        }
    }
    
    @Test func fetchContent_InvalidResponse_ThrowsError() async {
        let session = URLSession.failingStub
        networkService = NetworkService(session: session, contentURL: testURL)
        
        await #expect(throws: NetworkError.invalidResponse) {
            try await networkService.fetchContent()
        }
    }
    
    @Test func fetchContent_InvalidData_ThrowsError() async {
        let session = URLSession.invalidDataStub
        networkService = NetworkService(session: session, contentURL: testURL)
        
        await #expect(throws: NetworkError.decodingError) {
            try await networkService.fetchContent()
        }
    }
    
    @Test func fetchContent_ValidData_ReturnsContent() async throws {
        let testItem = try ContentItem(title: "Test Item")
        let session = URLSession.stub(with: testItem)
        networkService = NetworkService(session: session, contentURL: testURL)
        
        let content = try await networkService.fetchContent()
        #expect(content.count == 1)
        #expect(content[0].title == testItem.title)
    }
}

private extension URLSession {
    static var failingStub: URLSession {
        URLProtocolStub.responseStatus = 400
        return stubSession
    }
    
    static var invalidDataStub: URLSession {
        URLProtocolStub.responseStatus = 200
        URLProtocolStub.testData = "invalid".data(using: .utf8)!
        return stubSession
    }
    
    static func stub(with item: ContentItem) -> URLSession {
        URLProtocolStub.testData = try! JSONEncoder().encode(item)
        return stubSession
    }
    
    private static var stubSession: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }
}

private class URLProtocolStub: URLProtocol {
    static var testData: Data?
    static var responseStatus: Int = 200
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: Self.responseStatus,
            httpVersion: nil,
            headerFields: nil
        )!
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = Self.testData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
