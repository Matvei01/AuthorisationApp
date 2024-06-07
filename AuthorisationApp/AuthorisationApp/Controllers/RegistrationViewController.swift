//
//  RegistrationViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - Private Properties
    private var storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var nameTextField = ReuseTextField(
        placeholder: "Имя",
        returnKeyType: .next,
        tag: 0
    )
    private lazy var emailTextField = ReuseTextField(
        placeholder: "Почта",
        returnKeyType: .next,
        tag: 1
    )
    private lazy var passwordTextField = ReuseTextField(
        placeholder: "Пароль",
        isSecureTextEntry: true,
        returnKeyType: .done,
        tag: 2
    )
    
    private lazy var registrationLabel = ReuseLabel(
        text: "Регистрация",
        textColor: .white,
        font: .systemFont(ofSize: 34.4, weight: .bold),
        textAlignment: .center
    )
    
    private lazy var privacyPolicyLabel = ReuseLabel(
        text: "Я согласен с Условиями предоставления услуг и Политикой конфиденциальности",
        textColor: .appGray,
        font: .systemFont(ofSize: 13.76, weight: .regular)
    )
    
    private lazy var questionLabel = ReuseLabel(
        text: "Уже есть аккаунт?",
        textColor: .appDark,
        font: .systemFont(ofSize: 18.35, weight: .regular)
    )
    
    private lazy var registrationButton = ReuseLargeButton(
        title: "РЕГИСТРАЦИЯ",
        target: self,
        selector: #selector(registrationButtonTapped)
    )
    
    private lazy var signInButton = ReuseSmallButton(
        title: "ВОЙТИ",
        target: self,
        selector: #selector(signInButtonTapped)
    )
    
    private lazy var textFieldsStackView = ReuseStackView(
        subviews: [nameTextField, emailTextField, passwordTextField],
        axis: .vertical,
        alignment: .fill,
        spacing: 10
    )
    
    private lazy var firstRegistrationStackView = ReuseStackView(
        subviews: [
            registrationLabel,
            textFieldsStackView,
            privacyPolicyLabel
        ],
        axis: .vertical,
        alignment: .fill,
        spacing: 15
    )
    
    private lazy var secondRegistrationStackView = ReuseStackView(
        subviews: [
            registrationButton,
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
        spacing: 50.98
    )
    
    private lazy var signInStackView = ReuseStackView(
        subviews: [
            questionLabel,
            signInButton
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
private extension RegistrationViewController {
    func setupView() {
        view.backgroundColor = .appBlack
        
        addSubviews()
        
        setupTextFields(
            nameTextField,
            emailTextField,
            passwordTextField
        )
        
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
    
    @objc func registrationButtonTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        storageManager.name = name
        storageManager.email = email
        storageManager.password = password
        
        NotificationCenter.default.post(name: .showSignIn, object: nil)
    }
    
    @objc func signInButtonTapped() {
        NotificationCenter.default.post(name: .showSignIn, object: nil)
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            emailTextField.becomeFirstResponder()
        case 1:
            passwordTextField.becomeFirstResponder()
        default:
            registrationButtonTapped()
        }
        return true
    }
}

// MARK: - Constraints
private extension RegistrationViewController {
    func setConstraints() {
        setConstraintsFor(mainRegistrationStackView)
        
        setConstraintsFor(
            largeAuthButton: registrationButton,
            smallAuthButton: signInButton,
            widthAnchorForSmallButton: 60
        )
        
        setConstraintsFor(
            nameTextField,
            emailTextField,
            passwordTextField
        )
    }
}



