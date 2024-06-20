//
//  ProfileViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 01.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let signOutService = SignOutService.shared
    private let loadingUserDataService = LoadingUserDataService.shared
    private let updateDataService = UpdateDataService.shared
    
    // MARK: - UI Elements
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(loadImageTapped)
        )
        return tapGestureRecognizer
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = ReuseImageView(
            tapGestureRecognizer: tapGestureRecognizer
        )
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = ReuseLabel(
            textColor: .appBlack,
            font: .systemFont(ofSize: 15, weight: .medium)
        )
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = ReuseLabel(
            textColor: .appBlack,
            font: .systemFont(ofSize: 15, weight: .medium)
        )
        return label
    }()
    
    private lazy var birthDateLabel: UILabel = {
        let label = ReuseLabel(
            textColor: .appBlack,
            font: .systemFont(ofSize: 15, weight: .medium)
        )
        return label
    }()
    
    private lazy var nameFieldTitleLabel: UILabel = {
        let label = ReuseLabel(
            text: "Имя:",
            textColor: .appBlack,
            font: .systemFont(ofSize: 14, weight: .regular)
        )
        return label
    }()
    
    private lazy var emailFieldTitleLabel: UILabel = {
        let label = ReuseLabel(
            text: "Email:",
            textColor: .appBlack,
            font: .systemFont(ofSize: 14, weight: .regular)
        )
        return label
    }()
    
    private lazy var birthDayFieldTitleLabel: UILabel = {
        let label = ReuseLabel(
            text: "Дата рождения:",
            textColor: .appBlack,
            font: .systemFont(ofSize: 14, weight: .regular)
        )
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = ReuseProfileButton(
            title: "Выход",
            target: self,
            selector: #selector(logoutButtonTapped),
            imageName: "pip.exit"
        )
        return button
    }()
    
    private lazy var notesButton: UIButton = {
        let button = ReuseProfileButton(
            title: "Мои заметки",
            target: self,
            selector: #selector(notesButtonTapped),
            imageName: "list.bullet.clipboard.fill"
        )
        return button
    }()
    
    private lazy var namePencilButton: UIButton = {
        let button = ReusePencilButton(
            target: self,
            selector: #selector(pencilButtonTapped),
            tag: 0
        )
        return button
    }()
    
    private lazy var birthDatePencilButton: UIButton = {
        let button = ReusePencilButton(
            target: self,
            selector: #selector(pencilButtonTapped),
            tag: 1
        )
        return button
    }()
    
    private lazy var emailPencilButton: UIButton = {
        let button = ReusePencilButton(
            target: self,
            selector: #selector(pencilButtonTapped),
            tag: 2
        )
        return button
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                nameFieldTitleLabel,
                nameLabel,
                namePencilButton
            ],
            axis: .horizontal,
            alignment: .fill,
            spacing: 5
        )
        return stackView
    }()
    
    private lazy var birthDateStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                birthDayFieldTitleLabel,
                birthDateLabel,
                birthDatePencilButton
            ],
            axis: .horizontal,
            alignment: .fill,
            spacing: 5
        )
        return stackView
    }()
    
    private lazy var emailStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [emailFieldTitleLabel, emailLabel, emailPencilButton],
            axis: .horizontal,
            alignment: .fill,
            spacing: 5
        )
        return stackView
    }()
    
    private lazy var mainInfoUsersLabelsStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                nameStackView,
                birthDateStackView,
                emailStackView
            ],
            axis: .vertical,
            alignment: .leading,
            spacing: 5
        )
        return stackView
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [profileImageView, mainInfoUsersLabelsStackView],
            axis: .vertical,
            alignment: .center,
            spacing: 30
        )
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [notesButton, logoutButton],
            axis: .vertical,
            alignment: .fill,
            spacing: 15
        )
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [profileStackView, buttonsStackView],
            axis: .vertical,
            alignment: .fill,
            autoresizing: false,
            spacing: 50
        )
        return stackView
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
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
    
    private lazy var nameTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Введите свое имя"
        )
        textField.layer.borderColor = UIColor.appRed.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        return textField
    }()
    
    private lazy var birthDateTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Введите свою дату рождения"
        )
        textField.layer.borderColor = UIColor.appRed.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.inputView = datePicker
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = ReuseTextField(
            placeholder: "Введите свой email"
        )
        textField.layer.borderColor = UIColor.appRed.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8.0
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var toolbarName: UIToolbar = {
        createToolbar(
            textField: nameTextField,
            saveButtonAction: #selector(saveNameButtonTapped),
            cancelButtonAction: #selector(cancelNameButtonTapped)
        )
    }()
    
    private lazy var toolbarBirthDate: UIToolbar = {
        createToolbar(
            textField: birthDateTextField,
            saveButtonAction: #selector(saveBirthDateButtonTapped),
            cancelButtonAction: #selector(cancelBirthDateButtonTapped)
        )
    }()
    
    private lazy var toolbarEmail: UIToolbar = {
        createToolbar(
            textField: emailTextField,
            saveButtonAction: #selector(saveEmailButtonTapped),
            cancelButtonAction: #selector(cancelEmailButtonTapped)
        )
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .white
        
        addSubviews()
        
        setupNavigationBar()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(mainStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        title = "Мой профиль"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func loadImageTapped() {
        present(imagePicker, animated: true)
    }
    
    func formatBirthDate(_ birthDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: birthDate)
    }
    
    func fetchUserData() {
        loadingUserDataService.loadingUserData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                self.nameLabel.text = "\(userData.name)"
                self.emailLabel.text = "\(userData.email)"
                self.birthDateLabel.text = "\(self.formatBirthDate(userData.birthDate))"
                self.loadProfileImage(for: userData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadProfileImage(for userData: LoadUserData) {
        guard let imageUrl = userData.imageUrl else {
            print("Image URL is not available")
            return
        }
        
        if let url = URL(string: imageUrl) {
            profileImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "person.crop.circle.fill.badge.plus")
            )
        }
    }
    
    func uploadImageToFirebase(image: UIImage) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        UploadImageService.shared.uploadImage(currentUserId: currentUserId, imageData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imageUrl):
                self.updateDataService.updateUserImageUrl(imageUrl) { result in
                    switch result {
                    case .success(_):
                        self.showAlert(title: "Success", message: "Photo successfully updated")
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            case .failure(let error):
                print("Error uploading image: \(error.localizedDescription)")
            }
        }
    }
    
    func promptForPassword(completion: @escaping (String?) -> Void) {
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
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Za-z0-9._%+-]+@gmail\\.com$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func createToolbar(textField: UITextField,
                       saveButtonAction: Selector,
                       cancelButtonAction: Selector) -> UIToolbar {
        
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let textFieldItem = UIBarButtonItem(customView: textField)
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: cancelButtonAction
        )
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: saveButtonAction
        )
        
        saveButton.tintColor = .appRed
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolbar.setItems(
            [
                cancelButton,
                flexibleSpace,
                textFieldItem,
                flexibleSpace,
                saveButton
            ],
            animated: false
        )
        return toolbar
    }
    
    func setupPencilButtonAction(for textField: UITextField, label: UILabel, toolbar: UIToolbar) {
        textField.text = label.text
        view.addSubview(toolbar)
        textField.becomeFirstResponder()
        setConstraintsForToolbar(toolbar)
    }
    
    private func cancelEditing(for textField: UITextField, toolbar: UIToolbar) {
        textField.resignFirstResponder()
        toolbar.removeFromSuperview()
    }
}

// MARK: - Button Actions
private extension ProfileViewController {
    
    @objc func pencilButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            setupPencilButtonAction(
                for: nameTextField,
                label: nameLabel,
                toolbar: toolbarName
            )
        case 1:
            setupPencilButtonAction(
                for: birthDateTextField,
                label: birthDateLabel,
                toolbar: toolbarBirthDate
            )
        default:
            setupPencilButtonAction(
                for: emailTextField,
                label: emailLabel,
                toolbar: toolbarEmail
            )
        }
    }
    
    @objc func logoutButtonTapped() {
        signOutService.signOut { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: .showSignIn, object: nil)
            case .failure(let failure):
                self.showAlert(title: "Error", message: failure.localizedDescription)
            }
        }
    }
    
    @objc func notesButtonTapped() {
        print("Перейти в мои заметки")
    }
    
    @objc func cancelNameButtonTapped() {
        cancelEditing(
            for: nameTextField,
            toolbar: toolbarName
        )
    }
    
    @objc func cancelBirthDateButtonTapped() {
        cancelEditing(
            for: birthDateTextField,
            toolbar: toolbarBirthDate
        )
    }
    
    @objc func cancelEmailButtonTapped() {
        cancelEditing(
            for: emailTextField,
            toolbar: toolbarEmail
        )
    }
    
    @objc func saveNameButtonTapped() {
        guard let newName = nameTextField.text, !newName.isEmpty else { return }
        
        nameLabel.text = newName
        updateDataService.updateUserName(newName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.showAlert(title: "Success", message: "Name successfully updated")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        nameTextField.resignFirstResponder()
        toolbarName.removeFromSuperview()
    }
    
    @objc func saveBirthDateButtonTapped() {
        guard let newBirthDateText = birthDateTextField.text, !newBirthDateText.isEmpty else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let newBirthDate = dateFormatter.date(from: newBirthDateText) {
            birthDateLabel.text = newBirthDateText
            updateDataService.updateUserBirthDate(newBirthDate) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    self.showAlert(title: "Success", message: "Birth date successfully updated")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        
        birthDateTextField.resignFirstResponder()
        toolbarBirthDate.removeFromSuperview()
    }
    
    @objc func saveEmailButtonTapped() {
        guard let newEmail = emailTextField.text, !newEmail.isEmpty else { return }
        
        promptForPassword { [weak self] password in
            guard let self = self else { return }
            
            guard let password = password else { return }
            if isValidEmail(newEmail) {
                emailLabel.text = newEmail
                self.updateDataService.updateAuthEmail(newEmail, password: password) { result in
                    switch result {
                    case .success(_):
                        self.showAlertForUpdateData(title: "Success", message: "Email successfully updated. You will be redirected to the login screen and will have to log in again. A link has been sent to your new email address. Please click on it to verify.")
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            } else {
                self.showAlert(title: "Error", message: "Invalid email format")
            }
        }
        
        emailTextField.resignFirstResponder()
        toolbarEmail.removeFromSuperview()
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        birthDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            uploadImageToFirebase(image: editedImage)
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Constraints
private extension ProfileViewController {
    func setConstraints() {
        setConstraintsForMainStackView()
        
        setConstraintsFor(
            logoutButton,
            notesButton
        )
    }
    
    func setConstraintsFor(_ buttons: UIButton...) {
        for button in buttons {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    func setConstraintsForMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -50
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 40
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            )
        ])
    }
    
    func setConstraintsForToolbar() {
        NSLayoutConstraint.activate([
            toolbarName.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),
            toolbarName.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            toolbarName.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            toolbarName.heightAnchor.constraint(
                equalToConstant: 120
            )
        ])
    }
    
    func setConstraintsForToolbar(_ toolbar: UIToolbar) {
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(
                equalTo: view.keyboardLayoutGuide.topAnchor
            ),
            toolbar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            toolbar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            toolbar.heightAnchor.constraint(
                equalToConstant: 140
            )
        ])
    }
}
