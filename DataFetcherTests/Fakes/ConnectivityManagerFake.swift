@testable import DataFetcher
import Foundation

final class ConnectivityManagerFake: ConnectivityManager {

    init() {}
    
    // MARK: - ConnectivityManager
    
    var isConnected: Bool = true
}
