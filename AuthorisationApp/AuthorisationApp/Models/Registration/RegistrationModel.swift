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
    func register(userData: RegUserData, imageData: Data, completion: @escaping(Result<Bool, Error>) -> ()) {
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                print("UID не найден.")
                return
            }
            
            result?.user.sendEmailVerification { error in
                if let error = error {
                    print("Ошибка верификации email: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                self.uploadAvatarImage(uid: uid, imageData: imageData, userData: userData, completion: completion)
            }
        }
    }
    
    private func uploadAvatarImage(uid: String, imageData: Data, userData: RegUserData, completion: @escaping (Result<Bool, Error>) -> ()) {
        UploadAvatarImageService.shared.uploadImage(currentUserId: uid, imageData) { result in
            switch result {
            case .success(let imageUrl):
                self.setUserData(
                    uid: uid,
                    name: userData.name,
                    birthDate: userData.birthDate,
                    imageUrl: imageUrl,
                    completion: completion
                )
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private func setUserData(uid: String,
                             name: String,
                             birthDate: Date,
                             imageUrl: String,
                             completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let userData: [String: Any] = [
            "name": name,
            "birthDate": Timestamp(date: birthDate),
            "imageUrl": imageUrl
        ]
        
        Firestore.firestore()
            .collection("users")
            .document(uid)
            .setData(userData) { error in
                if let error = error {
                    print("Ошибка сохранения данных пользователя: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
    }
}
