//
//  ReuseImageView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 15.06.2024.
//

import UIKit

final class ReuseImageView: UIImageView {
    
    init(image: UIImage? = nil, tapGestureRecognizer: UITapGestureRecognizer) {
        super.init(frame: .zero)
        setupImageView(image ?? UIImage(), tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(_ image: UIImage, _ tapGestureRecognizer: UITapGestureRecognizer) {
        self.image = image
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = 60
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
