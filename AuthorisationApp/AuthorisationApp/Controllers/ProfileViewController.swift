//
//  ProfileViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 01.06.2024.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let signOutService = SignOutService.shared
    private let networkDataFetcher = NetworkDataFetcher.shared
    
    // MARK: - UI Elements
    private lazy var profileImageView = ReuseImageView(
        image: UIImage(systemName: "person.crop.circle.fill.badge.plus") ?? UIImage()
    )
    
    private lazy var nameLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
    private lazy var emailLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 16, weight: .medium)
    )
    
    private lazy var birthDayLabel = ReuseLabel(
        textColor: .appBlack,
        font: .systemFont(ofSize: 16, weight: .medium)
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
        subviews: [profileImageView, labelsStackView],
        axis: .vertical,
        alignment: .center,
        spacing: 30
    )
    
    private lazy var labelsStackView = ReuseStackView(
        subviews: [nameLabel, emailLabel, birthDayLabel],
        axis: .vertical,
        alignment: .fill,
        spacing: 10
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
    
    func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: Date())
        return components.year ?? 0
    }
    
    func fetchUserData() {
        networkDataFetcher.fetchUserData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                self.nameLabel.text = "Name: \(userData.name)"
                self.emailLabel.text = "Email: \(userData.email)"
                self.birthDayLabel.text = "Age: \(self.calculateAge(from: userData.birthDate))"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
                constant: 70
            ),
            mainStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -70
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
}
