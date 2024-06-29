//
//  BaseNoteViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.06.2024.
//

import UIKit

class BaseNoteViewController: UIViewController {
    
    // MARK: - Public Properties
    var note: Note?
    
    // MARK: - UI Elements
    private(set) lazy var headerTextView: UITextView = {
        let textView = ReuseTextView(
            font: .systemFont(ofSize: 25, weight: .semibold)
        )
        return textView
    }()
    
    private(set) lazy var textNoteTextView: UITextView = {
        let textView = ReuseTextView(
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        return textView
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let label = ReuseLabel(
            text: "\(getCurrentDateTime()) | 0 символов",
            textColor: .systemGray,
            font: .systemFont(ofSize: 14)
        )
        return label
    }()
    
    private(set) lazy var headerLabel: UILabel = {
        let label = ReuseLabel(
            text: "Заголовок",
            textColor: .appBlack,
            font: .systemFont(ofSize: 25, weight: .semibold)
        )
        return label
    }()
    
    private(set) lazy var textNoteLabel: UILabel = {
        let label = ReuseLabel(
            text: "Текст",
            textColor: .appBlack,
            font: .systemFont(ofSize: 18, weight: .semibold)
        )
        return label
    }()
    
    private(set) lazy var noteImageView: UIImageView = {
        let imageView = ReuseImageView(
            image: .note,
            tapGestureRecognizer: tapGestureRecognizer,
            cornerRadius: 10,
            width: 170,
            height: 140
        )
        return imageView
    }()
    
    private(set) lazy var saveButton: UIButton = {
        let button = ReuseLargeButton(
            title: "СОХРАНИТЬ",
            target: self,
            selector: #selector(saveButtonTapped)
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var editNoteStackView: UIStackView = {
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
    
    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(noteImageTapped)
        )
        return tapGestureRecognizer
    }()
    
    private(set) lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerTextView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension BaseNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDateLabel()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension BaseNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            noteImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Internal methods
extension BaseNoteViewController {
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date())
    }
    
    func getCurrentDate() -> Date {
        return Date()
    }
}

// MARK: - Private methods
private extension BaseNoteViewController {
    func setupView() {
        view.backgroundColor = .white
        
        addSubviews()
        
        textNoteTextView.delegate = self
        
        setConstraints()
        
        setupNavigationBar()
    }
    
    func addSubviews() {
        setupSubviews(editNoteStackView, saveButton)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationController?.navigationBar.tintColor = .appRed
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func updateDateLabel() {
        let dateTimeString = getCurrentDateTime()
        let characterCount = textNoteTextView.text.count
        dateLabel.text = "\(dateTimeString) | \(characterCount) символов"
    }
    
    @objc func noteImageTapped() {
        present(imagePicker, animated: true)
    }
    
    func setConstraints() {
        setConstraintsForAddNoteStackView()
        setConstraintsFor(headerTextView, multiplier: 0.07)
        setConstraintsFor(textNoteTextView, multiplier: 0.2)
        setConstraintsForSaveButton()
    }
    
    func setConstraintsForAddNoteStackView() {
        NSLayoutConstraint.activate([
            editNoteStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -20
            ),
            editNoteStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            editNoteStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            )
        ])
    }
    
    func setConstraintsFor(_ textView: UITextView, multiplier: CGFloat) {
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(
                equalTo: editNoteStackView.widthAnchor
            ),
            textView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: multiplier
            )
        ])
    }
    
    func setConstraintsForSaveButton() {
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -50
            ),
            saveButton.leadingAnchor.constraint(
                equalTo: editNoteStackView.leadingAnchor
            ),
            saveButton.trailingAnchor.constraint(
                equalTo: editNoteStackView.trailingAnchor
            ),
            saveButton.heightAnchor.constraint(
                equalToConstant: 70
            )
        ])
    }
}

// MARK: - Overridable methods
@objc extension BaseNoteViewController {
    func saveButtonTapped() {}
    
    var backBarButtonItem: UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: UIAction { _ in
                NotificationCenter.default.post(name: .showNotes, object: nil)
            }
        )
    }
}
