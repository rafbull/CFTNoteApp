//
//  NotesListViewModelProtocol.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import Foundation
import Combine

protocol NotesListViewModelProtocol {
    var notes: CurrentValueSubject<[Note], Never> { get }
    
    func editNote(note: Note, at index: Int, isNewNote: Bool)
    func deleteNote(at index: Int)
    func createDefaultNote()
}
