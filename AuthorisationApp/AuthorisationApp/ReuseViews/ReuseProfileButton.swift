//
//  ReuseProfileButton.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 02.06.2024.
//

import UIKit

final class ReuseProfileButton: UIButton {
    
    // MARK: - Initializer
    init(
        title: String,
        target: Any?,
        selector: Selector,
        imageName: String? = nil,
        alignment :UIControl.ContentHorizontalAlignment? = nil,
        headerOffsetRight: CGFloat? = nil,
        autoresizing: Bool? = nil) {
            
            super.init(frame: .zero)
            setupButton(
                title: title,
                target: target,
                selector: selector,
                imageName: imageName,
                alignment: alignment ?? .left,
                headerOffsetRight: headerOffsetRight ?? 27,
                autoresizing: autoresizing ?? true
            )
        }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReuseProfileButton {
    func setupButton(
        title: String,
        target: Any?,
        selector: Selector,
        imageName: String?,
        alignment :UIControl.ContentHorizontalAlignment,
        headerOffsetRight: CGFloat,
        autoresizing: Bool) {
            
            self.backgroundColor = .appDarkProfileBtn
            self.setTitle(title, for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            self.layer.cornerRadius = 5
            self.addTarget(target, action: selector, for: .touchUpInside)
            self.contentHorizontalAlignment = alignment
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: headerOffsetRight,
                bottom: 0,
                right: 0
            )
            
            self.translatesAutoresizingMaskIntoConstraints = false
            
            if let imageName = imageName {
                let icon = UIImage(systemName: imageName)
                self.setImage(icon, for: .normal)
                self.imageView?.contentMode = .scaleAspectFit
                self.imageView?.tintColor = .white
                self.imageEdgeInsets = UIEdgeInsets(
                    top: 10,
                    left: 10,
                    bottom: 10,
                    right: 0
                )
            }
        }
}
