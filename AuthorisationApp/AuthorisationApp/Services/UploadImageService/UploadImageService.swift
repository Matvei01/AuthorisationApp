//
//  UploadImageService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 16.06.2024.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class UploadImageService {
    static let shared = UploadImageService()
    
    private init() {}
    
    func uploadImage(currentUserId: String, _ imageData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let imageName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child(currentUserId + "/avatars/").child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metaData) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url {
                    completion(.success(downloadURL.absoluteString))
                }
            }
        }
    }
    
    func updateUserImageUrl(_ imageUrl: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        userRef.updateData(["imageUrl": imageUrl]) { error in
            if let error = error {
                print("Error updating image URL: \(error.localizedDescription)")
            } else {
                print("Successfully updated image URL")
            }
        }
    }
}
