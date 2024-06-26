//
//  SignInViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Private Properties
    private let authModel = AuthModel()
    
    // MARK: - UI Elements
    private lazy var emailTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Почта",
            returnKeyType: .next
        )
        textField.tag = 0
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Пароль",
            isSecureTextEntry: true,
            returnKeyType: .done
        )
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = ReuseLabel(
            text: "Войти",
            textColor: .appBlack,
            font: .systemFont(ofSize: 34, weight: .bold),
            textAlignment: .center
        )
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = ReuseLabel(
            text: "У вас нет аккаунта?",
            textColor: .appDark,
            font: .systemFont(ofSize: 18, weight: .regular)
        )
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = ReuseLargeButton(
            title: "ВОЙТИ",
            target: self,
            selector: #selector(signInButtonTapped)
        )
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = ReuseSmallButton(
            title: "РЕГИСТРАЦИЯ",
            target: self,
            selector: #selector(registrationButtonTapped)
        )
        return button
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [emailTextField, passwordTextField],
            axis: .vertical,
            alignment: .fill,
            spacing: 15
        )
        return stackView
    }()
    
    private lazy var firstSignInStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                signInLabel,
                textFieldsStackView,
            ],
            axis: .vertical,
            alignment: .fill,
            spacing: 20
        )
        return stackView
    }()
    
    private lazy var secondSignInStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                signInButton,
                registrationInStackView
            ],
            axis: .vertical,
            alignment: .center,
            spacing: 28
        )
        return stackView
    }()
    
    private lazy var mainSignInStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                firstSignInStackView,
                secondSignInStackView
            ],
            axis: .vertical,
            alignment: .fill,
            autoresizing: false,
            spacing: 50
        )
        return stackView
    }()
    
    
    
    private lazy var registrationInStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                questionLabel,
                registrationButton
            ],
            axis: .horizontal,
            alignment: .fill,
            spacing: 9
        )
        return stackView
    }()
    
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
        view.backgroundColor = .white
        
        addSubviews()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(mainSignInStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    @objc func signInButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        let authUserData = AuthUserData(email: email, password: password)
        
        authModel.signIn(userData: authUserData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                switch success {
                case .verified:
                    print("Go to profile")
                    NotificationCenter.default.post(name: .showProfile, object: nil)
                case .noVerified:
                    self.showAlert(title: "Error", message: "Your email is not verified")
                }
            case .failure(let failure):
                self.showAlert(
                    title: "Error",
                    message: failure.localizedDescription,
                    textField: passwordTextField
                )
            }
        }
    }
    
    @objc func registrationButtonTapped() {
        NotificationCenter.default.post(name: .showRegister, object: nil)
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
        setConstraintsFor(mainSignInStackView)
        
        setConstraintsFor(
            largeAuthButton: signInButton,
            smallAuthButton: registrationButton,
            widthAnchorForSmallButton: 125,
            stackView: mainSignInStackView
        )
    }
}
