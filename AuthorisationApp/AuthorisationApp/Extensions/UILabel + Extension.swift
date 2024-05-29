//
//  UILabel + Extension.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.05.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
