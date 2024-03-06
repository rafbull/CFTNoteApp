//
//  CoreDataManager.swift
//  NotesCFT
//
//  Created by Rafis on 06.03.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesCFT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Methods for working with data entities
    
    func getDefaultNote() -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.title = "New Note"
        note.text = "Tap To Edit Note Text"
        note.date = .now
        return note
    }
    
    func fetchSavedNotes() throws -> [Note] {
        let noteFetchRequest = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        noteFetchRequest.sortDescriptors = [sortDescriptor]
        return try viewContext.fetch(noteFetchRequest)
    }
    
    func deleteNoteFromCoreData(_ note: Note) throws {
        viewContext.delete(note)
        
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    func editNote(_ noteId: UUID?, with newNote: Note) {
        
        guard let noteId = noteId else { return }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = NSPredicate(format: "id = %@", noteId as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            let editedNote = (try viewContext.fetch(request)).first as! Note
            
            editedNote.title = newNote.title
            editedNote.text = newNote.text
            editedNote.date = newNote.date
           
            self.saveContext()
           
        } catch {
            print("Can't edit note: \(error)")
        }
    }
}
