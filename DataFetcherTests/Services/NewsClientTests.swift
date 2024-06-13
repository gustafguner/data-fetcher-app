@testable import DataFetcher
import Foundation
import XCTest

final class NewsClientTests: XCTestCase {
    
    private var networkClientFake: NetworkClientFake!
    private var environmentManagerFake: EnvironmentManagerFake!
    private var newsClient: NewsClient!
    
    private let apiKey = "fakeApiKey"
    private lazy var expectedRequestURL: URL = {
        URL(string: "https://api.nytimes.com/svc/topstories/v2/technology.json?api-key=\(apiKey)")!
    }()
    
    override func setUp() {
        super.setUp()
        networkClientFake = NetworkClientFake()
        environmentManagerFake = EnvironmentManagerFake()
        environmentManagerFake.apiKey = apiKey
        newsClient = WebAPIService.provideNewsClient(
            networkClient: networkClientFake,
            environmentManager: environmentManagerFake
        )
    }
    
    // MARK: - Tests
    
    func test_getArticles_invokesNetworkClient() {
        // Given
        let articlesResponse: ArticlesResponse = .mock()
        networkClientFake.responseData = articlesResponse.toData()
        
        let expectation = expectation(description: "Network request")
        
        // When/Then
        Task {
            do {
                let _ = try await newsClient.getArticles(refresh: false)
                
                XCTAssertEqual(
                    networkClientFake.requestInvocations,
                    [.init(url: expectedRequestURL, refresh: false)]
                )
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }

        wait(for: [expectation])
    }
    
    func test_getArticles_refresh_invokesNetworkClient() {
        // Given
        let articlesResponse: ArticlesResponse = .mock()
        networkClientFake.responseData = articlesResponse.toData()
        
        let expectation = expectation(description: "Network request")
        
        // When/Then
        Task {
            do {
                let _ = try await newsClient.getArticles(refresh: true)
                
                XCTAssertEqual(
                    networkClientFake.requestInvocations,
                    [.init(url: expectedRequestURL, refresh: true)]
                )
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }

        wait(for: [expectation])
    }
    
    func test_getArticles_resolvesWithExpectedData() {
        // Given
        let articlesResponse: ArticlesResponse = .mock()
        networkClientFake.responseData = articlesResponse.toData()
        
        let expectation = expectation(description: "Network request")
        
        // When
        Task {
            do {
                let data = try await newsClient.getArticles(refresh: false)
                XCTAssertEqual(data, articlesResponse)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        // Then
        wait(for: [expectation])
    }
    
    func test_getArticles_invalidData_throwsDecodingError() {
        // Given
        networkClientFake.responseData = Data()
        let expectation = expectation(description: "Network request")
        
        // When
        Task {
            do {
                let _ = try await newsClient.getArticles(refresh: false)
                XCTFail("Expected error to be thrown")
            } catch {
                if case NewsClientError.decodingError = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected error type")
                }
            }
        }
        
        // Then
        wait(for: [expectation])
    }
}

private extension ArticlesResponse {
    func toData() -> Data {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        return jsonData
    }
}
