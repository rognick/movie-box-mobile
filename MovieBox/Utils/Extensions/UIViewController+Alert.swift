//
//  UIViewController+Alert.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import UIKit

extension UIViewController {
    func showErrorAlert(handler: ((UIAlertAction) -> Void)? = nil) {
        showErrorAlert(withTitle: "shared_error_title".localized,
                       message: "shared_error_message".localized,
                       handler: handler)
    }
    func showErrorAlert(withTitle title: String, message: String = "", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(
                title: "shared_error_cancel_action".localized,
                style: .cancel,
                handler: handler
            )
        )

        present(alertController, animated: true, completion: nil)
    }
}
