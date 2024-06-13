import UIKit

enum AlertService {
    static func provideAlertManager() -> AlertManager {
        AlertManagerImpl.shared
    }
}

protocol AlertManager {
    func presentAlert(title: String, message: String)
}

private final class AlertManagerImpl: AlertManager {
    
    // MARK: - Internal
    
    static let shared = AlertManagerImpl()
    
    // MARK: - AlertManager

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))

        UIApplication.topViewController.map {
            $0.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private init() {}
}

private extension UIApplication {
    static var topViewController: UIViewController? {
        UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.rootViewController
    }
}
