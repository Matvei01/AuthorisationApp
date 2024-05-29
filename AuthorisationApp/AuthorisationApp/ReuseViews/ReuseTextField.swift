//
//  ReuseTextField.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class ReuseTextField: UITextField {
    // MARK: - Private Properties
    private let padding  = UIEdgeInsets(
        top: 26.37,
        left: 21.79,
        bottom: 25.72,
        right: 21.79
    )
    
    // MARK: - Initializer
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

// MARK: - Private methods
private extension ReuseTextField {
    func setupTextField(placeholder: String) {
        self.layer.cornerRadius = 11.47
        self.backgroundColor = .appClear
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: 16)
    }
}
