//
//  ReuseLargeButton.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 30.05.2024.
//

import UIKit

final class ReuseLargeButton: UIButton {
    
    // MARK: - Initializer
    init(title: String, selector: Selector) {
        super.init(frame: .zero)
        setupButton(title: title, selector: selector)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReuseLargeButton {
    func setupButton(title: String, selector: Selector) {
        self.backgroundColor = .appPurple
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.05, weight: .bold)
        self.layer.cornerRadius = 13.76
        self.addTarget(self, action: selector, for: .touchUpInside)
    }
}
