//
//  SignInViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Private Properties
    private var storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var emailTextField = ReuseTextField(
        placeholder: "Почта",
        returnKeyType: .next,
        tag: 0
    )
    private lazy var passwordTextField = ReuseTextField(
        placeholder: "Пароль",
        isSecureTextEntry: true,
        returnKeyType: .done,
        tag: 1
    )
    
    private lazy var registrationLabel = ReuseLabel(
        text: "Войти",
        textColor: .white,
        font: .systemFont(ofSize: 34.4, weight: .bold),
        textAlignment: .center
    )
    
    private lazy var questionLabel = ReuseLabel(
        text: "У вас нет аккаунта?",
        textColor: .appDark,
        font: .systemFont(ofSize: 18.35, weight: .regular)
    )
    
    private lazy var signInButton = ReuseLargeButton(
        title: "ВОЙТИ",
        target: self,
        selector: #selector(signInButtonTapped)
    )
    
    private lazy var registrationButton = ReuseSmallButton(
        title: "РЕГИСТРАЦИЯ",
        target: self,
        selector: #selector(registrationButtonTapped)
    )
    
    private lazy var textFieldsStackView = ReuseStackView(
        subviews: [emailTextField, passwordTextField],
        axis: .vertical,
        alignment: .fill,
        spacing: 10
    )
    
    private lazy var firstRegistrationStackView = ReuseStackView(
        subviews: [
            registrationLabel,
            textFieldsStackView,
        ],
        axis: .vertical,
        alignment: .fill,
        spacing: 15
    )
    
    private lazy var secondRegistrationStackView = ReuseStackView(
        subviews: [
            signInButton,
            signInStackView
        ],
        axis: .vertical,
        alignment: .center,
        spacing: 28.67
    )
    
    private lazy var mainRegistrationStackView = ReuseStackView(
        subviews: [
            firstRegistrationStackView,
            secondRegistrationStackView
        ],
        axis: .vertical,
        alignment: .fill,
        autoresizing: false,
        spacing: 50.89
    )
    
    private lazy var signInStackView = ReuseStackView(
        subviews: [
            questionLabel,
            registrationButton
        ],
        axis: .horizontal,
        alignment: .fill,
        spacing: 9.81
    )
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Private methods
private extension SignInViewController {
    func setupView() {
        view.backgroundColor = .appBlack
        
        addSubviews()
        
        setupTextFields(emailTextField, passwordTextField)
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(mainRegistrationStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupTextFields(_ textFields: UITextField...) {
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    @objc func signInButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        if email == storageManager.email && password == storageManager.password {
            NotificationCenter.default.post(name: .showProfile, object: nil)
        } else {
            showAlert(
                title: "Ошибка",
                message: "Неверные данные",
                textField: passwordTextField
            )
        }
    }
    
    @objc func registrationButtonTapped() {
        NotificationCenter.default.post(name: .showRegister, object: nil)
    }
}

// MARK: - Alert Controller
extension SignInViewController {
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        default:
            signInButtonTapped()
        }
        return true
    }
}

// MARK: - Constraints
private extension SignInViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainRegistrationStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 50
            ),
            
            mainRegistrationStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 27.52
            ),
            mainRegistrationStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -27.52
            ),
            
            emailTextField.heightAnchor.constraint(
                equalToConstant: 71.09
            ),
            passwordTextField.heightAnchor.constraint(
                equalToConstant: 71.09
            ),
            
            signInButton.heightAnchor.constraint(equalToConstant: 71.09),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            registrationButton.widthAnchor.constraint(equalToConstant: 125)
        ])
    }
}
