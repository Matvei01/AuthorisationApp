//
//  UpdateDataService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 19.06.2024.
//

import FirebaseAuth
import FirebaseFirestore

final class UpdateDataService {
    
    static let shared = UpdateDataService()
    
    private init() {}
    
    private func updateUserField(_ field: String, value: Any, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData([field: value]) { error in
            if let error = error {
                completion(.failure(.updateFailed))
                print("Error updating \(field): \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserImageUrl(_ imageUrl: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        updateUserField("imageUrl", value: imageUrl, completion: completion)
    }
    
    func updateUserName(_ newName: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        updateUserField("name", value: newName, completion: completion)
    }
    
    func updateUserBirthDate(_ newBirthDate: Date, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        let timestamp = Timestamp(date: newBirthDate)
        updateUserField("birthDate", value: timestamp, completion: completion)
    }
    
    func updateUserEmail(_ newEmail: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        updateUserField("email", value: newEmail) { [weak self] result in
            switch result {
            case .success:
                self?.sendVerificationEmail(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reauthenticateUser(password: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        guard let email = user.email else {
            completion(.failure(.updateFailed))
            print("Email not found.")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(.failure(.reauthenticationFailed))
                print("Error reauthenticating user: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateAuthEmail(_ newEmail: String, password: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        reauthenticateUser(password: password) { [weak self] result in
            switch result {
            case .success:
                guard let user = Auth.auth().currentUser else {
                    completion(.failure(.userNotAuthenticated))
                    print("User not authenticated.")
                    return
                }
                user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                    if let error = error {
                        completion(.failure(.emailVerificationFailed))
                        print("Error sending email verification: \(error.localizedDescription)")
                    } else {
                        self?.updateUserEmail(newEmail, completion: completion)
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendVerificationEmail(completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        user.sendEmailVerification { error in
            if let error = error {
                completion(.failure(.emailVerificationFailed))
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
}

extension UpdateDataService {
    enum LoadDataError: Error {
        case userNotAuthenticated
        case updateFailed
        case emailVerificationFailed
        case reauthenticationFailed
    }
}
