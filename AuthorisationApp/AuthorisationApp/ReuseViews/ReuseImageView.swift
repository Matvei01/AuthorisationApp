//
//  ReuseImageView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 15.06.2024.
//

import UIKit

final class ReuseImageView: UIImageView {
    
    init(image: UIImage, radius: CGFloat? = nil) {
        super.init(frame: .zero)
        setupImageView(image: image, radius: radius ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(image: UIImage, radius: CGFloat) {
        self.image = image
        self.tintColor = .appRed
        self.self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
