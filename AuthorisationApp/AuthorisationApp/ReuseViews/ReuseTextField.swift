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
    
    // MARK: - UI Elements
    private lazy var eyeButton = UIButton(type: .custom)
    
    // MARK: - Initializer
    init(placeholder: String,
         isSecureTextEntry: Bool? = nil,
         returnKeyType: UIReturnKeyType,
         tag: Int) {
        
        super.init(frame: .zero)
        setupTextField(
            placeholder,
            isSecureTextEntry ?? false,
            returnKeyType,
            tag
        )
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
    func setupTextField(_ placeholder: String,
                        _ isSecureTextEntry: Bool,
                        _ returnKeyType: UIReturnKeyType,
                        _ tag: Int) {
        
        self.layer.cornerRadius = 11.47
        self.backgroundColor = .appClear
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: 16)
        self.isSecureTextEntry = isSecureTextEntry
        self.returnKeyType = returnKeyType
        self.tag = tag
        
        if isSecureTextEntry {
            self.textContentType = .oneTimeCode
            setupEyeButton()
        }
    }
    
    func setupEyeButton() {
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
        eyeButton.imageView?.tintColor = .appGray
        
        let containerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: eyeButton.intrinsicContentSize.width + 47,
                height: eyeButton.intrinsicContentSize.height
            )
        )
        
        eyeButton.frame = CGRect(
            x: 27,
            y: 0,
            width: eyeButton.intrinsicContentSize.width,
            height: eyeButton.intrinsicContentSize.height
        )
        
        containerView.addSubview(eyeButton)
        
        rightView = containerView
        rightViewMode = .always
    }
    
    @objc func eyeButtonTapped() {
        isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
}
