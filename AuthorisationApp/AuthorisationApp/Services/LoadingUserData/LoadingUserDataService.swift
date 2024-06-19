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
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(.documentRetrievalFailed))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let name = data["name"] as? String,
                  let birthDateTimestamp = data["birthDate"] as? Timestamp,
                  let imageUrl = data["imageUrl"] as? String else {
                completion(.failure(.invalidData))
                print("Invalid data received from server.")
                return
            }
            
            let birthDate = birthDateTimestamp.dateValue()
            let userData = LoadUserData(name: name, email: user.email ?? "No email", birthDate: birthDate, imageUrl: imageUrl)
            completion(.success(userData))
        }
    }
}

extension LoadingUserDataService {
    enum LoadDataError: Error {
        case userNotAuthenticated
        case invalidData
        case documentRetrievalFailed
        case updateFailed
        case emailVerificationFailed
        case reauthenticationFailed
    }
}


