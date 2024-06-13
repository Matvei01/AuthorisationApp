//
//  SignOutService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth

final class SignOutService {
    static let shared = SignOutService()
    
    private init() {}
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
            print("Exit")
        } catch {
            completion(.failure(error))
        }
    }
}

