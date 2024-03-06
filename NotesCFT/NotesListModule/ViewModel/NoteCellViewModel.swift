//
//  NoteCellViewModel.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import Foundation
import Combine

final class NoteCellViewModel: NoteCellViewModelProtocol {
    
    let noteTitle = CurrentValueSubject<String, Never>("")
    let noteText = CurrentValueSubject<String, Never>("")
    let noteDate = CurrentValueSubject<Date, Never>(Date())
    
    private let note: Note
    
    init(note: Note) {
        self.note = note
        setupPublisher()
    }
    
    private func setupPublisher() {
        noteTitle.send(note.title ?? "")
        noteText.send(note.text ?? "")
        noteDate.send(note.date ?? .now)
    }
}
