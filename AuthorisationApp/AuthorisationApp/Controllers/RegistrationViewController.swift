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
    
    private lazy var birthDateTextField = ReuseTextField(
        placeholder: "дд.мм.гггг",
        returnKeyType: .next,
        tag: 2
    )
    
    private lazy var passwordTextField = ReuseTextField(
        placeholder: "Пароль",
        isSecureTextEntry: true,
        returnKeyType: .done,
        tag: 3
    )
    
    private lazy var registrationLabel = ReuseLabel(
        text: "Регистрация",
        textColor: .appBlack,
        font: .systemFont(ofSize: 34.4, weight: .bold),
        textAlignment: .center
    )
    
    private lazy var privacyPolicyLabel = ReuseLabel(
        text: "Я согласен с Условиями предоставления услуг и Политикой конфиденциальности",
        textColor: .appGray,
        font: .systemFont(ofSize: 13.76, weight: .regular),
        numberOfLines: 0
    )
    
    private lazy var questionLabel = ReuseLabel(
        text: "Уже есть аккаунт?",
        textColor: .appDark,
        font: .systemFont(ofSize: 18.35, weight: .regular)
    )
    
    private lazy var loadLabel = ReuseLabel(
        text: "Загрузите ваше фото",
        textColor: .appBlack,
        font: .systemFont(ofSize: 16, weight: .semibold)
    )
    
    private lazy var loadImageView = ReuseImageView()
    
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
        subviews: [
            nameTextField,
            emailTextField,
            birthDateTextField,
            passwordTextField,
            loadStackView
        ],
        axis: .vertical,
        alignment: .fill,
        spacing: 15
    )
    
    private lazy var firstRegistrationStackView = ReuseStackView(
        subviews: [
            registrationLabel,
            textFieldsStackView,
            privacyPolicyLabel
        ],
        axis: .vertical,
        alignment: .fill,
        spacing: 20
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
        spacing: 30
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
    
    private lazy var loadStackView = ReuseStackView(
        subviews: [
            loadLabel,
            loadImageView
        ],
        axis: .horizontal,
        alignment: .center,
        spacing: 10
    )
    
    private lazy var datePicker = UIDatePicker()
    
    private lazy var imagePicker = UIImagePickerController()
    
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
        
        setupDatePicker()
        
        setupImagePicker()
        
        setupTapGestureRecognizer()
        
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
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneButtonTapped)
        toolbar.setItems([doneButton], animated: false)
        
        birthDateTextField.inputView = datePicker
        birthDateTextField.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        birthDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(loadImageTapped)
        )
        
        loadImageView.addGestureRecognizer(tapGestureRecognizer)
        loadImageView.isUserInteractionEnabled = true
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
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
        guard let birthDate = dateFormatter.date(from: birthDate) else {
            showAlert(title: "Error", message: "Invalid birth date format")
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
            case .failure(let failure):
                showAlert(title: "Error", message: failure.localizedDescription)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            loadImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Constraints
private extension RegistrationViewController {
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            loadImageView.heightAnchor.constraint(equalToConstant: 50),
            loadImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        setConstraintsFor(mainRegistrationStackView)
        
        setConstraintsFor(
            largeAuthButton: registrationButton,
            smallAuthButton: signInButton,
            widthAnchorForSmallButton: 60,
            stackView: mainRegistrationStackView
        )
    }
}



