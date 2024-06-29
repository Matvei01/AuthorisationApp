//
//  AddNotesViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 22.06.2024.
//

import UIKit

final class AddNotesViewController: BaseNoteViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Добавление новой заметки"
    }
    
    override func saveButtonTapped() {
        guard let title = headerTextView.text, !title.isEmpty,
              let text = textNoteTextView.text, !text.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        let date = getCurrentDate()
        let noteID = UUID().uuidString
        
        let note = Note(id: noteID, title: title, text: text, date: date, imageUrl: nil)
        
        let imageData = noteImageView.image?.jpegData(compressionQuality: 0.75)
        
        NotesDataService.shared.addNote(note: note, imageData: imageData) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: .showNotes, object: nil)
            case .failure(let error):
                print("Error adding note: \(error.localizedDescription)")
            }
        }
    }
}

