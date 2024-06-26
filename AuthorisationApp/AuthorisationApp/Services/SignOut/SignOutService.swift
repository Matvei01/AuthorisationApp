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
    
    func signOut(completion: @escaping (Result<Void, SignOutError>) -> Void) {
        do {
            try Auth.auth().signOut()
            print("User successfully signed out.")
            completion(.success(()))
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            completion(.failure(.signOutFailed(error)))
        }
    }
}

extension SignOutService {
    enum SignOutError: Error {
        case signOutFailed(Error)
    }
}

