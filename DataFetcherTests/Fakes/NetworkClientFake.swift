@testable import DataFetcher
import Foundation

final class NetworkClientFake: NetworkClient {
    
    private(set) var requestInvocations = [RequestInvocation]()
    
    struct RequestInvocation: Equatable {
        let url: URL
        let refresh: Bool
    }
    
    var responseData: Data = Data()
    
    init() {}
    
    // MARK: - NetworkClient
    
    func request(url: URL, refresh: Bool) async throws -> Data {
        requestInvocations.append(.init(url: url, refresh: refresh))
    
        return responseData
    }
}
