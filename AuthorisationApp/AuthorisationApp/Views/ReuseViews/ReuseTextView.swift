//
//  ReuseTextView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 24.06.2024.
//

import UIKit

final class ReuseTextView: UITextView {
    
    // MARK: - Initializer
    init(font: UIFont) {
        let textContainer = NSTextContainer(size: .zero)
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        super.init(frame: .zero, textContainer: textContainer)
        setupTextView(font: font)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextView(font: UIFont) {
        self.contentInset = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )
        self.font = font
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.appBlack.cgColor
        self.layer.borderWidth = 1.0
    }
}

