//
//  ReusePencilButton.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 17.06.2024.
//

import UIKit

final class ReusePencilButton: UIButton {
    
    // MARK: - Initializer
    init(imageName: String? = nil, target: Any?, selector: Selector, tag: Int) {
        super.init(frame: .zero)
        setupButton(imageName ?? "pencil", target, selector, tag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReusePencilButton {
    func setupButton(_ imageName: String, _ target: Any?, _ selector: Selector, _ tag: Int) {
        self.imageView?.tintColor = .appRed
        self.addTarget(target, action: selector, for: .touchUpInside)
        self.setImage(UIImage(systemName: imageName), for: .normal)
        self.tag = tag
    }
}
