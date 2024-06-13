import Foundation

enum EnvironmentService {
    static func provideEnvironmentManager() -> EnvironmentManager {
        EnvironmentManagerImpl.shared
    }
}

protocol EnvironmentManager {
    var apiKey: String { get }
}

private final class EnvironmentManagerImpl: EnvironmentManager {
    
    // MARK: - Environment
    
    var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("Unable to read API key from Configuration.")
        }
        
        return apiKey
    }
    
    // MARK: - Internal

    static let shared = EnvironmentManagerImpl()
    
    // MARK: - Private
    
    private init () {}
}
