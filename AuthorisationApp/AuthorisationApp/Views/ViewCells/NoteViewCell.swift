//
//  NoteViewCell.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 25.06.2024.
//

import UIKit
import SDWebImage

final class NoteViewCell: UITableViewCell {
    static let cellId = "NoteViewCell"
    
    // MARK: -  UI Elements
    private lazy var noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .appRed
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = ReuseLabel(
            text: "Header",
            textColor: .appBlack,
            font: .systemFont(ofSize: 20, weight: .semibold)
        )
        return label
    }()
    
    private lazy var textNoteLabel: UILabel = {
        let label = ReuseLabel(
            text: "Text note",
            textColor: .appBlack,
            font: .systemFont(ofSize: 16, weight: .medium)
        )
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = ReuseLabel(
            text: "25 июня 2024",
            textColor: .systemGray,
            font: .systemFont(ofSize: 14, weight: .regular)
        )
        return label
    }()
    
    private lazy var noteStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                headerLabel,
                textNoteLabel,
                dateLabel
            ],
            axis: .vertical,
            alignment: .fill,
            autoresizing: false,
            spacing: 5
        )
        return stackView
    }()
    
    // MARK: - Override Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with note: Note) {
        headerLabel.text = note.title
        textNoteLabel.text = note.text
        dateLabel.text = formatDate(note.date)
        if let imageUrlString = note.imageUrl, let imageUrl = URL(string: imageUrlString) {
            noteImageView.sd_setImage(with: imageUrl)
        }
    }
}

// MARK: - Private methods
private extension NoteViewCell {
    func setupView() {
        addSubviews()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(
            noteImageView,
            noteStackView
        )
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

// MARK: - Constraints
private extension NoteViewCell {
    func setConstraints() {
        setConstraintsForNoteImageView()
        setConstraintsForNoteStackView()
    }
    
    func setConstraintsForNoteImageView() {
        NSLayoutConstraint.activate([
            noteImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            noteImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 10
            ),
            noteImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
            noteImageView.trailingAnchor.constraint(
                equalTo: noteStackView.leadingAnchor,
                constant: -10
            ),
            noteImageView.widthAnchor.constraint(
                equalToConstant: 110
            )
        ])
    }
    
    func setConstraintsForNoteStackView() {
        NSLayoutConstraint.activate([
            noteStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            noteStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -20
            ),
            noteStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10
            )
        ])
    }
}
