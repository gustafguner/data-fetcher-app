@testable import DataFetcher
import Foundation

final class NewsClientFake: NewsClient {

    private(set) var getArticlesInvocations = [GetArticlesInvocation]()
    
    struct GetArticlesInvocation: Equatable {
        let refresh: Bool
    }
    
    var response: ArticlesResponse?
    
    init() {}
    
    // MARK: - NewsClient
    
    func getArticles(refresh: Bool) async throws -> ArticlesResponse {
        getArticlesInvocations.append(.init(refresh: refresh))
        
        guard let response else {
            throw NewsClientError.invalidURL
        }
        
        return response
    }
}
