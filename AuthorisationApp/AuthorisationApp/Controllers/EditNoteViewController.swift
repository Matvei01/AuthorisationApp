//
//  EditNoteViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 26.06.2024.
//

import UIKit
import SDWebImage

final class EditNoteViewController: BaseNoteViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Редактирование заметки"
        populateNoteDetails()
    }
    
    override func saveButtonTapped() {
        guard let title = headerTextView.text, !title.isEmpty,
              let text = textNoteTextView.text, !text.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все поля")
            return
        }
        
        let date = getCurrentDate()
        let noteID = note?.id ?? UUID().uuidString
        let note = Note(id: noteID, title: title, text: text, date: date, imageUrl: note?.imageUrl)
        
        let imageData = noteImageView.image?.jpegData(compressionQuality: 0.75)
        
        UpdateNotesService().updateNote(note: note, imageData: imageData) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: .showNotes, object: nil)
            case .failure(let error):
                print("Error updating note: \(error.localizedDescription)")
            }
        }
    }
    
    private func populateNoteDetails() {
        guard let note = note else { return }
        headerTextView.text = note.title
        textNoteTextView.text = note.text
        if let imageUrlString = note.imageUrl, let imageUrl = URL(string: imageUrlString) {
            noteImageView.sd_setImage(with: imageUrl)
        }
    }
}
