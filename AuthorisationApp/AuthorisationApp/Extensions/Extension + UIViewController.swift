//
//  Extension + UIViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 07.06.2024.
//

import UIKit

extension UIViewController {
    
    // MARK: - Reuse AlertController
    func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Reuse Constraints
    func setConstraintsFor(_ stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 40
            ),
            
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            )
        ])
    }
    
    func setConstraintsFor(largeAuthButton: UIButton,
                           smallAuthButton: UIButton,
                           widthAnchorForSmallButton: CGFloat,
                           stackView: UIStackView) {
        
        NSLayoutConstraint.activate([
            largeAuthButton.heightAnchor.constraint(equalToConstant: 71.09),
            largeAuthButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            smallAuthButton.widthAnchor.constraint(equalToConstant: widthAnchorForSmallButton)
        ])
    }
}
