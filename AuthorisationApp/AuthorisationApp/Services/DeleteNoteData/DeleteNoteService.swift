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
    
    func deleteNote(_ note: Note, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }
        
        let userID = user.uid
        let noteRef = db.collection("users").document(userID).collection("notes").document(note.id)
        
        noteRef.delete { error in
            if let error = error {
                completion(.failure(error))
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                completion(.success(()))
                print("Note successfully deleted.")
            }
        }
    }
}
