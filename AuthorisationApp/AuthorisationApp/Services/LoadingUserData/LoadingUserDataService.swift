//
//  LoadingUserDataService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 14.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class LoadingUserDataService {
    static let shared = LoadingUserDataService()
    
    private init() {}
    
    func loadingUserData(completion: @escaping (Result<LoadUserData, LoadDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Failed to retrieve document for user ID \(user.uid): \(error.localizedDescription)")
                completion(.failure(.documentRetrievalFailed(error)))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let name = data["name"] as? String,
                  let birthDateTimestamp = data["birthDate"] as? Timestamp,
                  let imageUrl = data["imageUrl"] as? String else {
                print("Invalid data received from server.")
                completion(.failure(.invalidData))
                return
            }
            
            let birthDate = birthDateTimestamp.dateValue()
            guard let email = user.email else {
                print("User email not found.")
                completion(.failure(.invalidData))
                return
            }
            let userData = LoadUserData(
                name: name,
                email: email,
                birthDate: birthDate,
                imageUrl: imageUrl
            )
            completion(.success(userData))
        }
    }
}

extension LoadingUserDataService {
    enum LoadDataError: Error {
        case userNotAuthenticated
        case invalidData
        case documentRetrievalFailed(Error)
    }
}


