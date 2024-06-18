//
//  ProfileViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 01.06.2024.
//

import UIKit
import FirebaseAuth
import SDWebImage

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let signOutService = SignOutService.shared
    private let networkDataFetcher = FetchDataService.shared
    
    // MARK: - UI Elements
    private lazy var profileImageView = ReuseImageView(radius: 74)
    
    private lazy var nameLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 15, weight: .medium)
    )
    
    private lazy var emailLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 15, weight: .medium)
    )
    
    private lazy var birthDayLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 15, weight: .medium)
    )
    
    private lazy var nameFieldTitleLabel = ReuseLabel(
        text: "Имя:",
        textColor: .appBlack,
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    
    private lazy var emailFieldTitleLabel = ReuseLabel(
        text: "Email:",
        textColor: .appBlack,
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    
    private lazy var birthDayFieldTitleLabel = ReuseLabel(
        text: "Дата рождения:",
        textColor: .appBlack,
        font: .systemFont(ofSize: 14, weight: .regular)
    )
    
    private lazy var editProfileButton = ReuseProfileButton(
        title: "Редактировать профиль",
        target: self,
        selector: #selector(editProfileButtonTapped),
        imageName: "gearshape.fill"
    )
    
    private lazy var notesButton = ReuseProfileButton(
        title: "Мои заметки",
        target: self,
        selector: #selector(notesButtonTapped),
        imageName: "list.bullet.clipboard.fill"
    )
    
    private lazy var logoutButton = ReuseProfileButton(
        title: "Выход",
        target: self,
        selector: #selector(logoutButtonTapped),
        alignment: .center,
        headerOffsetRight: 0,
        autoresizing: false
    )
    
    private lazy var namePencilButton = ReusePencilButton(
        target: self,
        selector: #selector(pencilButtonTapped),
        tag: 0
    )
    
    private lazy var birthDatePencilButton = ReusePencilButton(
        target: self,
        selector: #selector(pencilButtonTapped),
        tag: 1
    )
    
    private lazy var emailPencilButton = ReusePencilButton(
        target: self,
        selector: #selector(pencilButtonTapped),
        tag: 2
    )
    
    private lazy var nameStackView = ReuseStackView(
        subviews: [
            nameFieldTitleLabel,
            nameLabel,
            namePencilButton
        ],
        axis: .horizontal,
        alignment: .fill,
        spacing: 5
    )
    
    private lazy var birthDateStackView = ReuseStackView(
        subviews: [
            birthDayFieldTitleLabel,
            birthDayLabel,
            birthDatePencilButton
        ],
        axis: .horizontal,
        alignment: .fill,
        spacing: 5
    )
    
    private lazy var emailStackView = ReuseStackView(
        subviews: [emailFieldTitleLabel, emailLabel, emailPencilButton],
        axis: .horizontal,
        alignment: .fill,
        spacing: 5
    )
    
    private lazy var mainInfoUsersLabelsStackView = ReuseStackView(
        subviews: [
            nameStackView,
            birthDateStackView,
            emailStackView
        ],
        axis: .vertical,
        alignment: .leading,
        spacing: 5
    )
    
    private lazy var profileStackView = ReuseStackView(
        subviews: [profileImageView, mainInfoUsersLabelsStackView],
        axis: .vertical,
        alignment: .center,
        spacing: 30
    )
    
    private lazy var buttonsStackView = ReuseStackView(
        subviews: [notesButton, editProfileButton],
        axis: .vertical,
        alignment: .fill,
        spacing: 10
    )
    
    private lazy var mainStackView = ReuseStackView(
        subviews: [profileStackView, buttonsStackView],
        axis: .vertical,
        alignment: .fill,
        autoresizing: false,
        spacing: 40
    )
    
    private lazy var imagePicker = UIImagePickerController()
    
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
        
        setupImagePicker()
        
        setupTapGestureRecognizer()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(mainStackView, logoutButton)
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
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(loadImageTapped)
        )
        
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func loadImageTapped() {
        present(imagePicker, animated: true)
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    func formatBirthDate(_ birthDate: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: birthDate)
        }
    
    func fetchUserData() {
        networkDataFetcher.fetchUserData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                self.nameLabel.text = "\(userData.name)"
                self.emailLabel.text = "\(userData.email)"
                self.birthDayLabel.text = "\(self.formatBirthDate(userData.birthDate))"
                self.loadProfileImage(for: userData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadProfileImage(for userData: FetchUserData) {
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
            guard let _ = self else { return }
            
            switch result {
            case .success(let imageUrl):
                UploadImageService.shared.updateUserImageUrl(imageUrl)
            case .failure(let error):
                print("Error uploading image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Button Actions
private extension ProfileViewController {
    
    @objc func pencilButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Редактировать имя")
        case 1:
            print("Редактировать дату рождения")
        default:
            print("Редактировать email")
        }
    }
    
    @objc func editProfileButtonTapped() {
        print("Редактировать профиль")
    }
    
    @objc func notesButtonTapped() {
        print("Перейти в мои заметки")
    }
    
    @objc func logoutButtonTapped() {
        signOutService.signOut { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: .showRegister, object: nil)
            case .failure(let failure):
                self.showAlert(title: "Error", message: failure.localizedDescription)
            }
        }
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
        
        setConstraintsForLogoutButton()
        
        setConstraintsForProfileImageView()
        
        setConstraintsFor(
            editProfileButton,
            notesButton,
            logoutButton
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
    
    func setConstraintsForLogoutButton() {
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(
                equalTo: mainStackView.leadingAnchor
            ),
            logoutButton.trailingAnchor.constraint(
                equalTo: mainStackView.trailingAnchor
            ),
            logoutButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -60
            )
        ])
    }
    
    func setConstraintsForProfileImageView() {
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(
                equalToConstant: 148
            ),
            profileImageView.widthAnchor.constraint(
                equalToConstant: 148
            )
        ])
    }
    
    func setConstraintsForStackView(_ stackView: UIStackView, widthAnchorConstant: CGFloat) {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: widthAnchorConstant)
        ])
    }
}
