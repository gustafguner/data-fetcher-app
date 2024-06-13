import Foundation
import Network

enum ConnectivityService {
    static func provideConnectivityManager() -> ConnectivityManager {
        ConnectivityManagerImpl.shared
    }
}

public protocol ConnectivityManager {
    var isConnected: Bool { get }
}

private final class ConnectivityManagerImpl: ConnectivityManager {

    static let shared = ConnectivityManagerImpl()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }

    // MARK: - NetworkManager

    var isConnected: Bool = false
}
