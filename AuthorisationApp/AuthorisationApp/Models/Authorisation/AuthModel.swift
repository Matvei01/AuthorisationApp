//
//  AuthModel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth

final class AuthModel {
    func SignIn(userData: AuthUserData, completion: @escaping(Result<UserVerification, Error>) -> ()) {
        Auth.auth().signIn(withEmail: userData.email,
                           password: userData.password) { result, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let isVerify = result?.user.isEmailVerified, isVerify {
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
