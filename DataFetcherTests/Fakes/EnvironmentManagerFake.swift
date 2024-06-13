@testable import DataFetcher
import Foundation

final class EnvironmentManagerFake: EnvironmentManager {
    
    init() {}
    
    // MARK: - EnvironmentManager

    var apiKey: String = ""
}
