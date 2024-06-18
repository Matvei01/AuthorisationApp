//
//  ReusePencilButton.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 17.06.2024.
//

import UIKit

final class ReusePencilButton: UIButton {
    
    // MARK: - Initializer
    init(target: Any?, selector: Selector, tag: Int) {
        super.init(frame: .zero)
        setupButton(target, selector, tag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReusePencilButton {
    func setupButton(_ target: Any?, _ selector: Selector, _ tag: Int) {
        self.imageView?.tintColor = .appRed
        self.addTarget(target, action: selector, for: .touchUpInside)
        self.setImage(UIImage(systemName: "pencil"), for: .normal)
        self.tag = tag
    }
}
