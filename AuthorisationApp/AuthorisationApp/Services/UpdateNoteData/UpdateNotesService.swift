//
//  UpdateNotesService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 26.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UpdateNotesService {
    private let db = Firestore.firestore()
    
    func updateNote(note: Note, imageData: Data?, completion: @escaping (Result<Void, UpdateNoteError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        let userID = user.uid
        let noteData: [String: Any] = [
            "title": note.title,
            "text": note.text,
            "date": Timestamp(date: note.date)
        ]
        
        let document = db.collection("users").document(userID).collection("notes").document(note.id)
        
        document.updateData(noteData) { error in
            if let error = error {
                print("Failed to update note: \(error.localizedDescription)")
                completion(.failure(.noteUpdateFailed(error)))
                return
            }
            
            if let imageData = imageData {
                UploadNoteImageService.shared.uploadImage(documentID: note.id, imageData: imageData) { result in
                    switch result {
                    case .success(let imageUrl):
                        document.updateData(["imageUrl": imageUrl]) { error in
                            if let error = error {
                                print("Failed to update note with image URL: \(error.localizedDescription)")
                                completion(.failure(.noteUpdateFailed(error)))
                            } else {
                                completion(.success(()))
                            }
                        }
                    case .failure(let error):
                        print("Failed to upload image: \(error.localizedDescription)")
                        completion(.failure(.imageUploadFailed(error)))
                    }
                }
            } else {
                completion(.success(()))
            }
        }
    }
}

extension UpdateNotesService {
    enum UpdateNoteError: Error {
        case userNotAuthenticated
        case noteUpdateFailed(Error)
        case imageUploadFailed(Error)
    }
}
