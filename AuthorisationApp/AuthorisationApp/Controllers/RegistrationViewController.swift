//
//  RegistrationViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - Private Properties
    private let registrationModel = RegistrationModel()
    
    // MARK: - UI Elements
    private lazy var nameTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Имя",
            returnKeyType: .next
        )
        textField.tag = 0
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Почта",
            returnKeyType: .next
        )
        textField.tag = 1
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var birthDateTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "дд.мм.гггг",
            returnKeyType: .next
        )
        textField.tag = 2
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Пароль",
            isSecureTextEntry: true,
            returnKeyType: .done
        )
        textField.tag = 3
        return textField
    }()
    
    private lazy var privacyPolicyLabel: UILabel = {
        let label = ReuseLabel(
            text: "Я согласен с Условиями предоставления услуг и Политикой конфиденциальности",
            textColor: .appGray,
            font: .systemFont(ofSize: 13, weight: .regular),
            numberOfLines: 0
        )
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = ReuseLabel(
            text: "Уже есть аккаунт?",
            textColor: .appDark,
            font: .systemFont(ofSize: 18, weight: .regular)
        )
        return label
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(loadImageTapped)
        )
        return tapGestureRecognizer
    }()
    
    private lazy var loadImageView: UIImageView = {
        let imageView = ReuseImageView(
            image: .profile,
            tapGestureRecognizer: tapGestureRecognizer
        )
        return imageView
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = ReuseLargeButton(
            title: "РЕГИСТРАЦИЯ",
            target: self,
            selector: #selector(registrationButtonTapped)
        )
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = ReuseSmallButton(
            title: "ВОЙТИ",
            target: self,
            selector: #selector(signInButtonTapped)
        )
        return button
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                nameTextField,
                emailTextField,
                birthDateTextField,
                passwordTextField
            ],
            axis: .vertical,
            alignment: .fill,
            spacing: 15
        )
        return stackView
    }()
    
    private lazy var firstRegistrationStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                loadImageView,
                textFieldsStackView,
                privacyPolicyLabel
            ],
            axis: .vertical,
            alignment: .center,
            spacing: 25
        )
        return stackView
    }()
    
    private lazy var secondRegistrationStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                registrationButton,
                signInStackView
            ],
            axis: .vertical,
            alignment: .center,
            spacing: 20
        )
        return stackView
    }()
    
    private lazy var mainRegistrationStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                firstRegistrationStackView,
                secondRegistrationStackView
            ],
            axis: .vertical,
            alignment: .fill,
            autoresizing: false,
            spacing: 25
        )
        return stackView
    }()
    
    private lazy var signInStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                questionLabel,
                signInButton
            ],
            axis: .horizontal,
            alignment: .fill,
            spacing: 9
        )
        return stackView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Calendar.current.date(
            byAdding: .year,
            value: -18,
            to: Date()
        )
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneButtonTapped)
        toolbar.setItems([doneButton], animated: false)
        return toolbar
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    // MARK: -  Action
    private lazy var doneButtonTapped = UIAction { [unowned self] _ in
        birthDateTextField.resignFirstResponder()
    }
    
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
        view.backgroundColor = .white
        
        addSubviews()
        
        setupTextFields(
            nameTextField,
            emailTextField,
            birthDateTextField,
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
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        birthDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func loadImageTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func registrationButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let birthDate = birthDateTextField.text, !birthDate.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let image = loadImageView.image,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            showAlert(title: "Error", message: "Fill in all the fields")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let datePattern = "^\\d{2}\\.\\d{2}\\.\\d{4}$"
        let dateRegex = NSPredicate(format: "SELF MATCHES %@", datePattern)
        
        guard dateRegex.evaluate(with: birthDate),
              let birthDate = dateFormatter.date(from: birthDate) else {
            showAlert(title: "Error", message: "Invalid birth date format. Please use dd.MM.yyyy")
            return
        }
        
        let userData = RegUserData(name: name, email: email, birthDate: birthDate, password: password)
        
        registrationModel.register(userData: userData, imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                if success {
                    NotificationCenter.default.post(name: .showSignIn, object: nil)
                }
            case .failure(let error):
                showAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
            birthDateTextField.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
        default:
            registrationButtonTapped()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            loadImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Constraints
private extension RegistrationViewController {
    func setConstraints() {
        
        setConstraintsFor(
            nameTextField,
            emailTextField,
            birthDateTextField
        )
        
        setConstraintsForMainRegistrationStackView()
        
        setConstraintsFor(
            largeAuthButton: registrationButton,
            smallAuthButton: signInButton,
            widthAnchorForSmallButton: 60,
            stackView: mainRegistrationStackView
        )
    }
    
    func setConstraintsForMainRegistrationStackView() {
        NSLayoutConstraint.activate([
            mainRegistrationStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 25
            ),
            
            mainRegistrationStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            mainRegistrationStackView.trailingAnchor.constraint(
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
            largeAuthButton.heightAnchor.constraint(equalToConstant: 70),
            largeAuthButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            smallAuthButton.widthAnchor.constraint(equalToConstant: widthAnchorForSmallButton)
        ])
    }
    
    func setConstraintsFor(_ textFields: UITextField...) {
        for textField in textFields {
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(
                    equalTo: firstRegistrationStackView.widthAnchor
                )
            ])
        }
    }
}



