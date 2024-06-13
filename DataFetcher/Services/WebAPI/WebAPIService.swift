import Foundation

enum WebAPIService {
    static func provideNewsClient(
        networkClient: NetworkClient = NetworkService.provideNetworkClient(),
        environmentManager: EnvironmentManager = EnvironmentService.provideEnvironmentManager()
    ) -> NewsClient {
        NewsClientImpl(networkClient: networkClient, environmentManager: environmentManager)
    }
}

protocol NewsClient {
    func getArticles(refresh: Bool) async throws -> ArticlesResponse
}

private final class NewsClientImpl: NewsClient {
    
    // MARK: - Init

    init(networkClient: NetworkClient, environmentManager: EnvironmentManager) {
        self.networkClient = networkClient
        self.environmentManager = environmentManager
    }
        
    // MARK: - NewsClient
    
    func getArticles(refresh: Bool) async throws -> ArticlesResponse {
        guard let endpointURL else {
            throw NewsClientError.invalidURL
        }
        
        do {
            let data = try await networkClient.request(url: endpointURL, refresh: refresh)
            
            let decoder = JSONDecoder()
            let articles = try decoder.decode(ArticlesResponse.self, from: data)
            
            return articles
        } catch {
            if let networkClientError = error as? NetworkClientError {
                throw NewsClientError.networkError(networkClientError)
            }
            
            throw NewsClientError.decodingError(error)
        }
    }
    
    // MARK: - Private
    
    private let networkClient: NetworkClient
    private let environmentManager: EnvironmentManager
    
    private lazy var endpointURL: URL? = {
        .init(string: "https://api.nytimes.com/svc/topstories/v2/technology.json?api-key=\(environmentManager.apiKey)")
    }()
}

enum NewsClientError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}
