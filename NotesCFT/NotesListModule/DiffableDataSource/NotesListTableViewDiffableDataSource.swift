//
//  NotesListTableViewDiffableDataSource.swift
//  NotesCFT
//
//  Created by Rafis on 04.03.2024.
//

import UIKit

final class NotesListTableViewDiffableDataSource: UITableViewDiffableDataSource<NotesListTableViewSections, Note> {
    
    var deleteNoteFromViewModel: ((_ index: Int) -> Void)?
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var snapshot = self.snapshot()
        if editingStyle == .delete, let note = itemIdentifier(for: indexPath) {
            snapshot.deleteItems([note])
            apply(snapshot, animatingDifferences: true)
            deleteNoteFromViewModel?(indexPath.row)
        }
    }
}
