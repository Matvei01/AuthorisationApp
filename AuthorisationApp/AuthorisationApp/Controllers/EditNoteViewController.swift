//
//  EditNoteViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 26.06.2024.
//

import UIKit

final class EditNoteViewController: UIViewController {
    
    var note: Note?
    
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
    
    private lazy var editNoteStackView: UIStackView = {
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
    
    private lazy var saveButton: UIButton = {
        let button = ReuseLargeButton(
            title: "СОХРАНИТЬ",
            target: self,
            selector: #selector(saveButtonTapped)
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: -  Action
    private lazy var barButtonItemTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIBarButtonItem else { return }
        
        switch sender.tag {
        case 0:
            NotificationCenter.default.post(name: .showNotes, object: nil)
        default:
            print(2)
        }
    }
    
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
extension EditNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDateLabel()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            noteImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Private methods
private extension EditNoteViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        
        addSubviews()
        
        textNoteTextView.delegate = self
        
        populateNoteDetails()
        
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
        title = "Редактирование заметки"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationController?.navigationBar.tintColor = .appRed
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: Date())
    }
    
    func getCurrentDate() -> Date {
        return Date()
    }
    
    func populateNoteDetails() {
        guard let note = note else { return }
        headerTextView.text = note.title
        textNoteTextView.text = note.text
        dateLabel.text = formatDate(note.date)
        if let imageUrlString = note.imageUrl, let imageUrl = URL(string: imageUrlString) {
            noteImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    func updateDateLabel() {
        let dateTimeString = getCurrentDateTime()
        let characterCount = textNoteTextView.text.count
        dateLabel.text = "\(dateTimeString) | \(characterCount) символов"
    }
    
    @objc func noteImageTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func saveButtonTapped() {
        guard let title = headerTextView.text, !title.isEmpty,
              let text = textNoteTextView.text, !text.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        let date = getCurrentDate()
        let noteID = note?.id ?? UUID().uuidString
        let note = Note(id: noteID, title: title, text: text, date: date, imageUrl: note?.imageUrl)
        
        let imageData = noteImageView.image?.jpegData(compressionQuality: 0.75)
        
        UpdateNotesService().updateNote(note: note, imageData: imageData) { [weak self] result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: .showNotes, object: nil)
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Constraints
private extension EditNoteViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            editNoteStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -40
            ),
            editNoteStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            editNoteStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            ),
            
            headerTextView.widthAnchor.constraint(
                equalTo: editNoteStackView.widthAnchor
            ),
            headerTextView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.07
            ),
            
            textNoteTextView.widthAnchor.constraint(
                equalTo: editNoteStackView.widthAnchor
            ),
            textNoteTextView.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.2
            ),
            noteImageView.widthAnchor.constraint(equalToConstant: 170),
            noteImageView.heightAnchor.constraint(equalToConstant: 140),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            saveButton.leadingAnchor.constraint(equalTo: editNoteStackView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: editNoteStackView.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
