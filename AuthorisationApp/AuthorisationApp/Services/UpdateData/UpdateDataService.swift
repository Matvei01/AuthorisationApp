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
    
    func updateUserImageUrl(_ imageUrl: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData(["imageUrl": imageUrl]) { error in
            if let error = error {
                completion(.failure(.updateFailed))
                print("Error updating image URL: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserNameInFirebase(_ newName: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData(["name": newName]) { error in
            if let error = error {
                completion(.failure(.updateFailed))
                print("Error updating name: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserBirthDateInFirebase(_ newBirthDate: Date, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        let timestamp = Timestamp(date: newBirthDate)
        
        userRef.updateData(["birthDate": timestamp]) { error in
            if let error = error {
                completion(.failure(.updateFailed))
                print("Error updating birth date: \(error.localizedDescription)")
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUserEmailInFirebase(_ newEmail: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData(["email": newEmail]) { error in
            if let error = error {
                completion(.failure(.updateFailed))
                print("Error updating email: \(error.localizedDescription)")
            } else {
                self.sendVerificationEmail { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(.emailVerificationFailed))
                        print("Error sending verification email: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func reauthenticateUser(password: String, completion: @escaping (Result<Void, LoadDataError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.userNotAuthenticated))
            print("User not authenticated.")
            return
        }
        
        guard let email = user.email else { return }
        
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
            case .success():
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
                        self?.updateUserEmailInFirebase(newEmail) { result in
                            switch result {
                            case .success:
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(.updateFailed))
                                print("Error updating email in Firestore: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(.reauthenticationFailed))
                print("Error reauthenticating user: \(error.localizedDescription)")
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
        case invalidData
        case documentRetrievalFailed
        case updateFailed
        case emailVerificationFailed
        case reauthenticationFailed
    }
}
