import Foundation

enum NetworkService {
    static func provideNetworkClient(
        connectivityManager: ConnectivityManager = ConnectivityService.provideConnectivityManager()
    ) -> NetworkClient {
        NetworkClientImpl(connectivityManager: connectivityManager)
    }
}

protocol NetworkClient {
    /// Makes a network request using a given URL.
    /// - Parameters:
    ///   - url: The URL to make the network request using,.
    ///   - refresh: Whether the request should be refreshed, effectively ignoring any cache.
    func request(url: URL, refresh: Bool) async throws -> Data
}

private final class NetworkClientImpl: NetworkClient {
    
    // MARK: - Init
    
    init(connectivityManager: ConnectivityManager) {
        self.connectivityManager = connectivityManager
    }
    
    // MARK: - NetworkClient
    
    func request(url: URL, refresh: Bool) async throws -> Data {
        let cachePolicy: URLRequest.CachePolicy = refresh ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        let request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 10)
        
        guard connectivityManager.isConnected else {
            if !refresh, let cachedData = URLCache.shared.cachedResponse(for: request)?.data {
                return cachedData
            }
            
            throw NetworkClientError.noConnection
        }

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            throw NetworkClientError.requestFailed(error)
        }
    }
    
    // MARK: - Private
    
    private let connectivityManager: ConnectivityManager
}

enum NetworkClientError: Error {
    case noConnection
    case requestFailed(Error)
}
