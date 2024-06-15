//
//  ReuseLabel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

final class ReuseLabel: UILabel {
    
    // MARK: - Initializer
    init(text: String? = nil,
         textColor: UIColor,
         font: UIFont,
         textAlignment: NSTextAlignment? = nil) {
        
        super.init(frame: .zero)
        setupLabel(text ?? "", textColor, font, textAlignment ?? .left)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension ReuseLabel {
    func setupLabel(_ text: String,
                    _ textColor: UIColor,
                    _ font: UIFont,
                    _ textAlignment: NSTextAlignment) {
        
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = 0
        self.textAlignment = textAlignment
    }
}
