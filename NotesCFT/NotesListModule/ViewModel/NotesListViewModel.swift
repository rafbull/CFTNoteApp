//
//  NotesListViewModel.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import Foundation
import Combine

final class NotesListViewModel: NotesListViewModelProtocol {
    var notes = CurrentValueSubject<[Note], Never>([Note]())
    lazy var coreDataManager = CoreDataManager.shared
    
    init() {
        self.fetchNotesFromCoreData()
    }
    
    func deleteNote(at index: Int) {
        let note = notes.value[index]
        do {
            try coreDataManager.deleteNoteFromCoreData(note)
            notes.value.remove(at: index)
        } catch {
            print("Cannot delete note: \(error.localizedDescription)")
        }
    }
    
    func editNote(note: Note, at index: Int, isNewNote: Bool) {
        if isNewNote {
            notes.value.insert(note, at: index)
        } else {
            let editingNoteId = notes.value[index].id
            notes.value[index] = note
            coreDataManager.editNote(editingNoteId, with: note)
        }
        coreDataManager.saveContext()
    }
    
    func createDefaultNote() {
        guard notes.value.isEmpty else { return }
        let note = coreDataManager.getDefaultNote()
        notes.value.append(note)
    }
    
    func fetchNotesFromCoreData() {
        do {
            let savedNotes = try coreDataManager.fetchSavedNotes()
            notes.send(savedNotes)
        } catch {
            print("Cannot get saved notes: \(error.localizedDescription)")
        }
    }
}
