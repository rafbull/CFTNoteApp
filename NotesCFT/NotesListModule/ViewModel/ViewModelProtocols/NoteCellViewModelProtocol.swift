//
//  NoteCellViewModelProtocol.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import Foundation
import Combine

protocol NoteCellViewModelProtocol {
    
    var noteTitle: CurrentValueSubject<String, Never> { get }
    var noteText: CurrentValueSubject<String, Never> { get }
    var noteDate: CurrentValueSubject<Date, Never> { get }
    
    init(note: Note)
}
