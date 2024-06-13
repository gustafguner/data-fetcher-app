@testable import DataFetcher
import Foundation

final class AlertManagerFake: AlertManager {

    private(set) var presentAlertInvocations = [PresentAlertInvocation]()
    
    struct PresentAlertInvocation: Equatable {
        let title: String
        let message: String
    }

    // MARK: - AlertManager
    
    func presentAlert(title: String, message: String) {
        presentAlertInvocations.append(.init(title: title, message: message))
    }
}
