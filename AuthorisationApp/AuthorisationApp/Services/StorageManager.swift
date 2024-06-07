//
//  StorageManager.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 02.06.2024.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()

    var name: String?
    var email: String?
    var password: String?
    
    private init() {}
}
