//
//  NoteDetailViewModelProtocol.swift
//  NotesCFT
//
//  Created by Rafis on 04.03.2024.
//

import Foundation
import Combine

protocol NoteDetailViewModelProtocol {
    var noteTitle: CurrentValueSubject<String, Never> { get }
    var noteText: CurrentValueSubject<String, Never> { get }
    var noteDate: CurrentValueSubject<Date, Never> { get }
    var noteId: CurrentValueSubject<UUID, Never> { get }
    
    var updatedNote: Note { get }
    
    func updateNote(with text: String, and date: Date)

    init(note: Note?)
}
