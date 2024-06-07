//
//  ReuseSmallButton.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 30.05.2024.
//

import UIKit

final class ReuseSmallButton: UIButton {
    
    // MARK: - Initializer
    init(title: String, target: Any?, selector: Selector) {
        super.init(frame: .zero)
        setupButton(title, target, selector)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReuseSmallButton {
    func setupButton(_ title: String, _ target: Any?, _ selector: Selector) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.appPurple, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.05, weight: .bold)
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
}
