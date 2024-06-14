//
//  AppModel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth

final class AppModel {
    func isUserLogin() -> Bool {
        if let _ = Auth.auth().currentUser?.uid {
            return true
        } else {
            return false
        }
    }
}
