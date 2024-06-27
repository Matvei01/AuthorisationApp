//
//  NotesViewController.swift
//  AuthorisationApp
//
//  Created by Matvei Khlestov on 25.06.2024.
//

import UIKit

final class NotesViewController: UITableViewController {
    
    // MARK: -  Private Properties
    private var notes: [Note] = []
    private var filteredNotes: [Note] = []
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: -  UI Elements
    private lazy var searchController = UISearchController(
        searchResultsController: nil
    )
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: barButtonItemTapped
        )
        button.tag = 0
        return button
    }()
    
    private lazy var addNoteBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            systemItem: .add,
            primaryAction: barButtonItemTapped
        )
        button.tag = 1
        return button
    }()
    
    // MARK: -  Action
    private lazy var barButtonItemTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIBarButtonItem else { return }
        
        switch sender.tag {
        case 0:
            barButtonItemAction(notificationName: .showProfile)
        default:
            barButtonItemAction(notificationName: .showAddNote)
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Table view data source
extension NotesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteViewCell.cellId, for: indexPath)
        guard let cell = cell as? NoteViewCell else { return UITableViewCell() }
        let note: Note
        if isFiltering {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        cell.configure(with: note)
        return cell
    }
}

// MARK: - Table view delegate
extension NotesViewController {
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            handleDeleteAction(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        NotificationCenter.default.post(name: .showEditNote, object: nil, userInfo: ["note": note])
    }
}

// MARK: - Private methods
private extension NotesViewController {
    func setupTableView() {
        tableView.register(
            NoteViewCell.self,
            forCellReuseIdentifier: NoteViewCell.cellId
        )
        
        tableView.rowHeight = 110
        
        fetchNotes()
        
        setupNavigationBar()
        
        setupSearchController()
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        title = "Мои заметки"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appBlack
        ]
        navigationController?.navigationBar.tintColor = .appRed
        
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = addNoteBarButtonItem
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск заметок"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func barButtonItemAction(notificationName: Notification.Name) {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func fetchNotes() {
        LoadingNotesDataService.shared.fetchNotes { [weak self] result in
            switch result {
            case .success(let notes):
                self?.notes = notes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch notes: \(error)")
            }
        }
    }
    
    private func handleDeleteAction(at indexPath: IndexPath) {
        let note: Note
        
        if isFiltering {
            note = filteredNotes[indexPath.row]
            removeNoteFromDataSource(note: note, at: indexPath.row)
        } else {
            note = notes[indexPath.row]
            removeNoteFromDataSource(note: note, at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        deleteNoteFromFirebase(note: note)
    }
    
    private func removeNoteFromDataSource(note: Note, at index: Int) {
        if isFiltering {
            filteredNotes.remove(at: index)
            if let indexInNotes = notes.firstIndex(where: { $0.id == note.id }) {
                notes.remove(at: indexInNotes)
            }
        } else {
            notes.remove(at: index)
            if let indexInFilteredNotes = filteredNotes.firstIndex(where: { $0.id == note.id }) {
                filteredNotes.remove(at: indexInFilteredNotes)
            }
        }
    }
    
    private func deleteNoteFromFirebase(note: Note) {
        DeleteNoteService().deleteNote(note) { result in
            switch result {
            case .success:
                print("Note successfully deleted from Firebase.")
            case .failure(let error):
                print("Failed to delete note from Firebase: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            return note.title.lowercased().contains(searchText.lowercased()) || note.text.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}


