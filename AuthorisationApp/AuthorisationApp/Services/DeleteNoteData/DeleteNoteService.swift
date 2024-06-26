//
//  DeleteNoteService.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 26.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DeleteNoteService {
    
    private let db = Firestore.firestore()
    
    func deleteNote(_ note: Note, completion: @escaping (Result<Void, DeleteNoteError>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(.failure(.userNotAuthenticated))
            return
        }
        
        let userID = user.uid
        let noteRef = db.collection("users").document(userID).collection("notes").document(note.id)
        
        noteRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
                completion(.failure(.documentDeletionFailed(error)))
            } else {
                print("Note successfully deleted.")
                completion(.success(()))
            }
        }
    }
}

extension DeleteNoteService {
    enum DeleteNoteError: Error {
        case userNotAuthenticated
        case documentDeletionFailed(Error)
    }
}
