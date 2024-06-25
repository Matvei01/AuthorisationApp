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
    
    func uploadImage(documentID: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }
        
        let userID = user.uid
        let imageName = "\(documentID).jpg"
        let storageRef = Storage.storage().reference().child("users/\(userID)/notes/").child(imageName)
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
}
