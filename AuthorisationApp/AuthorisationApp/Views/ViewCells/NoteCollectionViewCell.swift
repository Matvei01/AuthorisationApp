//
//  NoteCollectionViewCell.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 22.06.2024.
//

import UIKit

final class NoteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let cellId = "NoteViewCell"
    
    // MARK: -  UI Elements
    private let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = ReuseLabel(
            text: "HEADER",
            textColor: .appBlack,
            font: .systemFont(ofSize: 16, weight: .semibold)
        )
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = ReuseLabel(
            text: "Выполнить домашнюю работуhhhjhhuhuuhhhuu",
            textColor: .appBlack,
            font: .systemFont(ofSize: 16, weight: .regular)
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = ReuseLabel(
            text: "22 июня",
            textColor: .appBlack,
            font: .systemFont(ofSize: 16, weight: .regular)
        )
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = ReuseStackView(
            subviews: [
                headerLabel,
                textLabel,
                dateLabel
            ],
            axis: .vertical,
            alignment: .fill,
            autoresizing: false,
            spacing: 10
        )
        return stackView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with header: String, text: String, date: String) {
            headerLabel.text = header
            textLabel.text = text
            dateLabel.text = date
        }
}

// MARK: - Private methods
private extension NoteCollectionViewCell {
    func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 10
        
        addSubviews()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(
            noteImageView,
            labelsStackView
        )
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}

// MARK: - Constraints
private extension NoteCollectionViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            noteImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            noteImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            noteImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            noteImageView.bottomAnchor.constraint(
                equalTo: labelsStackView.topAnchor,
                constant: -10
            ),
            
            noteImageView.widthAnchor.constraint(equalToConstant: 185),
            noteImageView.heightAnchor.constraint(equalToConstant: 125),
            
            labelsStackView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -10
        ),
            labelsStackView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 20
        ),
            labelsStackView.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -20
            )
        ])
    }
}



