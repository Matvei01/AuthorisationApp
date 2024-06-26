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
    
    private func updateUserField(_ field: String, value: Any, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData([field: value]) { error in
            if let error = error {
                print("Error updating \(field): \(error.localizedDescription)")
                completion(.failure(.updateFailed(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserImageUrl(_ imageUrl: String, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        updateUserField("imageUrl", value: imageUrl, completion: completion)
    }
    
    func updateUserName(_ newName: String, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        updateUserField("name", value: newName, completion: completion)
    }
    
    func updateUserBirthDate(_ newBirthDate: Date, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        let timestamp = Timestamp(date: newBirthDate)
        updateUserField("birthDate", value: timestamp, completion: completion)
    }
    
    func updateUserEmail(_ newEmail: String, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        updateUserField("email", value: newEmail) { [weak self] result in
            switch result {
            case .success:
                self?.sendVerificationEmail(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reauthenticateUser(password: String, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        guard let email = user.email else {
            print("Email not found.")
            completion(.failure(.emailNotFound))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                print("Error reauthenticating user: \(error.localizedDescription)")
                completion(.failure(.reauthenticationFailed(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateAuthEmail(_ newEmail: String, password: String, completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        reauthenticateUser(password: password) { [weak self] result in
            switch result {
            case .success:
                guard let user = Auth.auth().currentUser else {
                    print("User not authenticated.")
                    completion(.failure(.userNotAuthenticated))
                    return
                }
                user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                    if let error = error {
                        print("Error sending email verification: \(error.localizedDescription)")
                        completion(.failure(.emailVerificationFailed(error)))
                    } else {
                        self?.updateUserEmail(newEmail, completion: completion)
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendVerificationEmail(completion: @escaping (Result<Void, UpdateDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
                completion(.failure(.emailVerificationFailed(error)))
            } else {
                completion(.success(()))
            }
        }
    }
}

extension UpdateDataService {
    enum UpdateDataError: Error {
        case userNotAuthenticated
        case updateFailed(Error)
        case emailVerificationFailed(Error)
        case reauthenticationFailed(Error)
        case emailNotFound
    }
}
