//
//  UploadNoteImageService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 25.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

final class UploadNoteImageService {
    static let shared = UploadNoteImageService()
    
    private init() {}
    
    func uploadImage(documentID: String, imageData: Data, completion: @escaping (Result<String, UploadNoteImageError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        let userID = user.uid
        let imageName = "\(documentID).jpg"
        let storageRef = Storage.storage().reference().child("users/\(userID)/notes/").child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metaData) { metadata, error in
            if let error = error {
                print("Error uploading image data: \(error.localizedDescription)")
                completion(.failure(.uploadFailed(error)))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(.urlRetrievalFailed(error)))
                } else if let downloadURL = url {
                    completion(.success(downloadURL.absoluteString))
                } else {
                    print("Download URL is nil.")
                    completion(.failure(.urlRetrievalFailed(nil)))
                }
            }
        }
    }
}

extension UploadNoteImageService {
    enum UploadNoteImageError: Error {
        case userNotAuthenticated
        case uploadFailed(Error)
        case urlRetrievalFailed(Error?)
    }
}
