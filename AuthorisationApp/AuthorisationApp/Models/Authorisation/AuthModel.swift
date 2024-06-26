//
//  AuthModel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth

final class AuthModel {
    func signIn(userData: AuthUserData, completion: @escaping(Result<UserVerification, AuthError>) -> ()) {
        Auth.auth().signIn(withEmail: userData.email, password: userData.password) { result, error in
            
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
                completion(.failure(.firebaseError(error)))
                return
            }
            
            guard let user = result?.user else {
                print("Unknown error occurred.")
                completion(.failure(.unknownError))
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
    
    enum AuthError: Error {
        case firebaseError(Error)
        case unknownError
    }
}
