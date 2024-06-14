//
//  RegistrationModel.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 13.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class RegistrationModel {
    func register(userData: RegUserData, completion: @escaping(Result<Bool, Error>) -> ()) {
        Auth.auth().createUser(withEmail: userData.email,
                               password: userData.password) { [weak self] result, error in
            
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            result?.user.sendEmailVerification()
            
            self.setUserData(uid: uid, name: userData.name)
            
            completion(.success(true))
        }
    }
    
    private func setUserData(uid: String, name: String) {
        let userData: [String: Any] = [
            "name": name,
            "isActive": true,
            "interests": ["work", "sport"]
        ]
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(userData)
    }
}
