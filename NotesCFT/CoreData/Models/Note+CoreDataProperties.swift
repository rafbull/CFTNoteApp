//
//  Note+CoreDataProperties.swift
//  NotesCFT
//
//  Created by Rafis on 06.03.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension Note : Identifiable {

}
