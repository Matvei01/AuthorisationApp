//
//  AddNotesViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 22.06.2024.
//

import UIKit

final class AddNotesViewController: UIViewController {
    
    // MARK: -  UI Elements
    private lazy var headerTextView: UITextView = {
        let textView = ReuseTextView(
            font: .systemFont(ofSize: 25, weight: .semibold)
        )
        return textView
    }()
    
    private let textNoteTextView: UITextView = {
        let textView = ReuseTextView(
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReuseLabel(
            text: "\(getCurrentDateTime()) | 0 символов",
            textColor: .systemGray,
            font: .systemFont(ofSize: 14)
        )
        return label
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = ReuseLabel(
            text: "Заголовок",
            textColor: .appBlack,
            font: .systemFont(ofSize: 25, weight: .semibold)
        )
        return label
    }()
    
    private lazy var textNoteLabel: UILabel = {
        let label = ReuseLabel(
            text: "Текст",
            textColor: .appBlack,
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        return label
    }()
    
    private lazy var addNoteStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                headerLabel,
                headerTextView,
                dateLabel,
                textNoteLabel,
                textNoteTextView,
                noteImageView
            ],
            axis: .vertical,
            alignment: .leading,
            autoresizing: false,
            spacing: 12
        )
        return stackView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: barButtonItemTapped
        )
        button.tag = 0
        return button
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(noteImageTapped)
        )
        return tapGestureRecognizer
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.badge.plus")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .appRed
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
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
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension AddNotesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDateLabel()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddNotesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            noteImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Private methods
private extension AddNotesViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        
        addSubviews()
        
        textNoteTextView.delegate = self
        
        setConstraints()
        
        setupNavigationBar()
    }
    
    func addSubviews() {
        setupSubviews(addNoteStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .appRed
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date())
    }
    
    func updateDateLabel() {
        let dateTimeString = getCurrentDateTime()
        let characterCount = textNoteTextView.text.count
        dateLabel.text = "\(dateTimeString) | \(characterCount) символов"
    }
    
    @objc func noteImageTapped() {
        present(imagePicker, animated: true)
    }
}

// MARK: - Constraints
private extension AddNotesViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            addNoteStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -40
            ),
            addNoteStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            addNoteStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            ),
            
            headerTextView.widthAnchor.constraint(
                equalTo: addNoteStackView.widthAnchor
            ),
            headerTextView.heightAnchor.constraint(
                equalToConstant: 80
            ),
            
            textNoteTextView.widthAnchor.constraint(
                equalTo: addNoteStackView.widthAnchor
            ),
            textNoteTextView.heightAnchor.constraint(
                equalToConstant: 250
            ),
            noteImageView.widthAnchor.constraint(equalToConstant: 180),
            noteImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
