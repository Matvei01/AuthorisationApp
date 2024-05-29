//
//  ReuseLabel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class ReuseLabel: UILabel {
    
    // MARK: - Initializer
    init(text: String, font: UIFont, titleColor: UIColor) {
        super.init(frame: .zero)
        setupLabel(text: text, textColor: textColor, font: font)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ReuseLabel {
    func setupLabel(text: String, textColor: UIColor, font: UIFont) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
