//
//  NotesListCoordinator.swift
//  NotesCFT
//
//  Created by Rafis on 05.03.2024.
//

import UIKit

final class NotesListCoordinator: Coordinator {
    
    var rootNavigationController: UINavigationController
    
    private let noteListViewModel: NotesListViewModelProtocol
    
    init(
        navigationController: UINavigationController = UINavigationController(),
        noteListViewModel: NotesListViewModelProtocol = NotesListViewModel()
    ) {
        self.rootNavigationController = navigationController
        self.noteListViewModel = noteListViewModel
        rootNavigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let notesListViewController = NotesListViewController(viewModel: noteListViewModel)
        
        notesListViewController.showDetailNoteRequest = { [weak self] selectedNote, index in
            self?.goToNoteDetail(selectedNote: selectedNote, index: index)
        }
        
        notesListViewController.createNewNote = { [weak self] in
            self?.goToNoteDetail()
        }
        rootNavigationController.setViewControllers([notesListViewController], animated: false)
    }
    
    private func goToNoteDetail(selectedNote: Note? = nil, index: Int? = 0) {
        let noteDetailViewModel = NoteDetailViewModel(note: selectedNote)
        let noteDetailViewController = NoteDetailViewController()
        
        noteDetailViewController.viewModel = noteDetailViewModel
        noteDetailViewController.noteIndex = index
        
        noteDetailViewController.editNoteRequest = { [weak self] editedNote, index in
            self?.noteListViewModel.editNote(note: editedNote, at: index, isNewNote: selectedNote == nil)
        }
        
        rootNavigationController.pushViewController(noteDetailViewController, animated: true)
    }
}
