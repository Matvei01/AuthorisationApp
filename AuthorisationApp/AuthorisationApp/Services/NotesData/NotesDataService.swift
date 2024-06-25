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
    
    func addNote(note: NoteData, imageData: Data?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
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
                completion(.failure(error))
                return
            }
            
            if let imageData = imageData, let documentID = documentRef?.documentID {
                UploadNoteImageService.shared.uploadImage(documentID: documentID, imageData: imageData) { result in
                    switch result {
                    case .success(let imageUrl):
                        documentRef?.updateData(["imageUrl": imageUrl]) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.success(()))
            }
        }
    }
}
