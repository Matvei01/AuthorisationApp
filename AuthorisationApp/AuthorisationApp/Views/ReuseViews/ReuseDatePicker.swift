//
//  ReuseDatePicker.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 29.06.2024.
//

import UIKit

final class ReuseDatePicker: UIDatePicker {
    
    // MARK: - Initializer
    init(target: Any?, action: Selector) {
        super.init(frame: .zero)
        setupDatePicker(target, action)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
extension ReuseDatePicker {
    private func setupDatePicker(_ target: Any?, _ action: Selector) {
        self.datePickerMode = .date
        self.maximumDate = Calendar.current.date(
            byAdding: .year,
            value: -18,
            to: Date()
        )
        self.preferredDatePickerStyle = .wheels
        self.addTarget(target, action: action, for: .valueChanged)
    }
}
