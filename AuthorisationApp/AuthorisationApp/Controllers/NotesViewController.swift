//
//  NotesViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 22.06.2024.
//

import UIKit

final class NotesViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    private let reuseIdentifier = "Cell"
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInserts = UIEdgeInsets(
        top: 20,
        left: 20,
        bottom: 20,
        right: 20
    )
    
    // MARK: -  UI Elements
    private lazy var addNoteButton: UIButton = {
        let button = ReusePencilButton(
            imageName: "plus.circle.fill",
            target: self,
            selector: #selector(addNoteButtonTapped),
            tag: 0
        )
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.layer.cornerRadius = 33
        button.imageEdgeInsets = UIEdgeInsets(
            top: 70,
            left: 70,
            bottom: 70,
            right: 70
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            primaryAction: barButtonItemTapped
        )
        button.tag = 0
        return button
    }()
    
    // MARK: -  Action
    private lazy var barButtonItemTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIBarButtonItem else { return }
        
        switch sender.tag {
        case 0:
            NotificationCenter.default.post(name: .showProfile, object: nil)
        default:
            print(2)
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
}

// MARK: UICollectionViewDataSource
extension NotesViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.cellId, for: indexPath)
        guard let cell = cell as? NoteCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension NotesViewController {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NotesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        sectionInserts.left
    }
}

// MARK: - Private methods
private extension NotesViewController {
    func setupCollectionView() {
        view.addSubview(addNoteButton)
        
        collectionView.register(
            NoteCollectionViewCell.self,
            forCellWithReuseIdentifier: NoteCollectionViewCell.cellId
        )
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        setupNavigationBar()
        
        setConstraints()
    }
    
    func addSubviews() {
        
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        title = "Мои заметки"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationController?.navigationBar.tintColor = .appRed
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func addNoteButtonTapped() {
        print("Add note")
    }
}

// MARK: - Constraints
private extension NotesViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addNoteButton.widthAnchor.constraint(equalToConstant: 66),
            addNoteButton.heightAnchor.constraint(equalTo: addNoteButton.widthAnchor)
        ])
    }
}
