//
//  AuthModel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth

final class AuthModel {
    func signIn(userData: AuthUserData, completion: @escaping(Result<UserVerification, Error>) -> ()) {
        Auth.auth().signIn(withEmail: userData.email, password: userData.password) { result, error in
            
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                print("User is not registered")
                return
            }
            
            if user.isEmailVerified {
                completion(.success(.verified))
            } else {
                completion(.success(.noVerified))
            }
        }
    }
}

extension AuthModel {
    enum UserVerification {
        case verified
        case noVerified
    }
}
