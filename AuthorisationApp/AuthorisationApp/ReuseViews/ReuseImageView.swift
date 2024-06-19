//
//  ReuseImageView.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 15.06.2024.
//

import UIKit

final class ReuseImageView: UIImageView {
    
    init(radius: CGFloat? = nil, tapGestureRecognizer: UITapGestureRecognizer) {
        super.init(frame: .zero)
        setupImageView(radius: radius ?? 0, tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(radius: CGFloat, _ tapGestureRecognizer: UITapGestureRecognizer) {
        self.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        self.tintColor = .appRed
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
}
