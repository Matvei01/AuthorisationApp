//
//  ProfileViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 01.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private var storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var profileImageView = UIImageView()
    
    private lazy var emailLabel = ReuseLabel(
        text: storageManager.email ?? "Invalid email",
        textColor: .white,
        font: .systemFont(ofSize: 28, weight: .semibold),
        textAlignment: .center
    )
    
    private lazy var accountButton = ReuseProfileButton(
        title: "Мой аккаунт",
        target: self,
        selector: #selector(accountButtonTapped),
        imageName: "person"
    )
    
    private lazy var settingsButton = ReuseProfileButton(
        title: "Настройки",
        target: self,
        selector: #selector(settingsButtonTapped),
        imageName: "gearshape"
    )
    
    private lazy var helpButton = ReuseProfileButton(
        title: "Помощь",
        target: self,
        selector: #selector(helpButtonTapped),
        imageName: "message"
    )
    
    private lazy var logoutButton = ReuseProfileButton(
        title: "Выход",
        target: self,
        selector: #selector(logoutButtonTapped),
        alignment: .center,
        headerOffsetRight: 0,
        autoresizing: false
    )
    
    private lazy var profileStackView = ReuseStackView(
        subviews: [profileImageView, emailLabel],
        axis: .vertical,
        alignment: .center,
        spacing: 30
    )
    
    private lazy var buttonsStackView = ReuseStackView(
        subviews: [accountButton, settingsButton, helpButton],
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
    
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .appBlack
        
        addSubviews()
        
        setupImageView()
        
        setupNavigationBar()
        
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
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupImageView() {
        profileImageView.image = UIImage(resource: .profile)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 74
    }
    
    @objc func accountButtonTapped() {
        print("Перейти в аккаунт")
    }
    
    @objc func settingsButtonTapped() {
        print("Перейти в настройки")
    }
    
    @objc func helpButtonTapped() {
        print("Перейти в тех поддержку")
    }
    
    @objc func logoutButtonTapped() {
        NotificationCenter.default.post(name: .showRegister, object: nil)
    }
}

// MARK: - Constraints
private extension ProfileViewController {
    func setConstraints() {
        setConstraintsForMainStackView()
        
        setConstraintsForLogoutButton()
        
        setConstraintsForProfileImageView()
        
        setConstraintsFor(
            accountButton,
            settingsButton,
            helpButton,
            logoutButton
        )
    }
    
    func setConstraintsFor(_ buttons: UIButton...) {
        for button in buttons {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
    func setConstraintsForMainStackView() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 5
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 71
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -69
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
                constant: -30
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
}
