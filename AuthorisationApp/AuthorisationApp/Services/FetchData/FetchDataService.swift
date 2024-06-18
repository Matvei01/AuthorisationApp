//
//  FetchDataService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 14.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FetchDataService {
    static let shared = FetchDataService()
    
    private init() {}
    
    func fetchUserData(completion: @escaping (Result<FetchUserData, FetchDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.invalidUser))
            print("User not authenticated.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if error != nil {
                completion(.failure(.unknownError))
                print("An unknown error occurred.")
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
            let userData = FetchUserData(name: name, email: user.email ?? "No email", birthDate: birthDate, imageUrl: imageUrl)
            completion(.success(userData))
        }
    }
}

extension FetchDataService {
    enum FetchDataError: Error {
        case invalidUser
        case invalidData
        case unknownError
    }
}


