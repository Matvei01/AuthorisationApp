//
//  ReuseImageView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 15.06.2024.
//

import UIKit

final class ReuseImageView: UIImageView {
    
    init(
        image: UIImage? = nil,
        tapGestureRecognizer: UITapGestureRecognizer,
        cornerRadius: CGFloat,
        width: CGFloat,
        height: CGFloat) {
            
        super.init(frame: .zero)
        setupImageView(
            image ?? UIImage(),
            tapGestureRecognizer,
            cornerRadius: cornerRadius,
            width,
            height
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(
        _ image: UIImage,
        _ tapGestureRecognizer: UITapGestureRecognizer,
        cornerRadius: CGFloat,
        _ width: CGFloat,
        _ height: CGFloat) {
            
        self.image = image
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
