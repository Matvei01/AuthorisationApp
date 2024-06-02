//
//  ReuseStackView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 30.05.2024.
//

import UIKit

final class ReuseStackView: UIStackView {
    
    // MARK: - Initializer
    init(subviews: [UIView],
         axis: NSLayoutConstraint.Axis,
         alignment: UIStackView.Alignment,
         autoresizing: Bool? = nil,
         spacing: CGFloat) {
        
        super.init(frame: .zero)
        setupStackView(
            subviews: subviews,
            axis: axis,
            alignment: alignment,
            autoresizing: autoresizing ?? true,
            spacing: spacing
        )
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension ReuseStackView {
    func setupStackView(subviews: [UIView],
                        axis: NSLayoutConstraint.Axis,
                        alignment: UIStackView.Alignment,
                        autoresizing: Bool,
                        spacing: CGFloat) {
        
        for subview in subviews {
            self.addArrangedSubview(subview)
        }
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = .fill
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = autoresizing
    }
}

