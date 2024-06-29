//
//  Extension + UIAlertController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.06.2024.
//

import UIKit

extension UIAlertController {
    
    // MARK: - Convenience Initializers
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    convenience init(title: String, message: String, okActionHandler: @escaping () -> Void) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okActionHandler()
        }
        addAction(okAction)
    }
    
    // MARK: - Reuse AlertController
    static func showAlert(on viewController: UIViewController, title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
    
    static func showAlertForUpdateEmail(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            SignOutService.shared.signOut { result in
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: .showSignIn, object: nil)
                case .failure(let failure):
                    UIAlertController.showAlert(on: viewController, title: "Error", message: failure.localizedDescription)
                }
            }
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }
    
    static func showPasswordPrompt(on viewController: UIViewController, completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: "Введите пароль",
            message: "Для изменения email введите текущий пароль",
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Пароль"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let password = alertController.textFields?.first?.text {
                completion(password)
            } else {
                completion(nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(nil)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
