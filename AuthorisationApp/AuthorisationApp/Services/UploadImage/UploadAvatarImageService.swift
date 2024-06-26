//
//  UploadAvatarImageService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 16.06.2024.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class UploadAvatarImageService {
    static let shared = UploadAvatarImageService()
    
    private init() {}
    
    func uploadImage(currentUserId: String, _ imageData: Data, completion: @escaping (Result<String, UploadImageError>) -> Void) {
        let imageName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference().child(currentUserId + "/avatars/").child(imageName)
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

extension UploadAvatarImageService {
    enum UploadImageError: Error {
        case uploadFailed(Error)
        case urlRetrievalFailed(Error?)
    }
}
