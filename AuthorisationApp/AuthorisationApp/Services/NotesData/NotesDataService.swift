//
//  NotesDataService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 21.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class NotesDataService {
    static let shared = NotesDataService()
    
    private init() {}
    
    private let db = Firestore.firestore()
    
    func addNote(note: Note, imageData: Data?, completion: @escaping (Result<Void, AddNoteError>) -> Void) {
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
        
        var documentRef: DocumentReference? = nil
        documentRef = db.collection("users").document(userID).collection("notes").addDocument(data: noteData) { error in
            if let error = error {
                print("Failed to create document: \(error.localizedDescription)")
                completion(.failure(.documentCreationFailed(error)))
                return
            }
            
            if let imageData = imageData, let documentID = documentRef?.documentID {
                UploadNoteImageService.shared.uploadImage(documentID: documentID, imageData: imageData) { result in
                    switch result {
                    case .success(let imageUrl):
                        documentRef?.updateData(["imageUrl": imageUrl]) { error in
                            if let error = error {
                                print("Failed to update image URL: \(error.localizedDescription)")
                                completion(.failure(.imageUrlUpdateFailed(error)))
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

extension NotesDataService {
    enum AddNoteError: Error {
        case userNotAuthenticated
        case documentCreationFailed(Error)
        case imageUploadFailed(Error)
        case imageUrlUpdateFailed(Error)
    }
}
