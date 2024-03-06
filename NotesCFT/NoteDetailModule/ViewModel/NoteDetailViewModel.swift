//
//  NoteDetailViewModel.swift
//  NotesCFT
//
//  Created by Rafis on 04.03.2024.
//

import Foundation
import Combine

final class NoteDetailViewModel: NoteDetailViewModelProtocol {
    let noteTitle = CurrentValueSubject<String, Never>("")
    let noteText = CurrentValueSubject<String, Never>("")
    let noteDate = CurrentValueSubject<Date, Never>(Date())
    let noteId = CurrentValueSubject<UUID, Never>(UUID())
    
    lazy var updatedNote: Note = {
        if let currentNote = self.note {
            currentNote.id = noteId.value
            currentNote.title = noteTitle.value
            currentNote.text = noteText.value
            currentNote.date = noteDate.value
            return currentNote
        } else {
            let newNote = Note(context: CoreDataManager.shared.viewContext)
            newNote.id = noteId.value
            newNote.title = noteTitle.value
            newNote.text = noteText.value
            newNote.date = noteDate.value
            return newNote
        }
    }()
    
    private let note: Note?
    
    init(note: Note?) {
        self.note = note
        setupPublisher()
    }
    
    func updateNote(with text: String, and date: Date) {

        let onlyTitle = text.split(separator: "\n").first?.description
        let onlyText = text.split(maxSplits: 1) { $0 == "\n" }.dropFirst().joined()

        noteTitle.send(onlyTitle ?? "")
        noteText.send(onlyText)
        noteDate.send(date)
    }
    
    private func setupPublisher() {
        noteId.send(note?.id ?? UUID())
        noteTitle.send(note?.title ?? "")
        noteText.send(note?.text ?? "")
        noteDate.send(note?.date ?? .now)
    }
}
