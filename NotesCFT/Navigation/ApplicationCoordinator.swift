//
//  ApplicationCoordinator.swift
//  NotesCFT
//
//  Created by Rafis on 05.03.2024.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let notesListCoordinator = NotesListCoordinator()
        notesListCoordinator.start()
        childCoordinators = [notesListCoordinator]
        window.rootViewController = notesListCoordinator.rootNavigationController
    }
}
