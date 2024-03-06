//
//  NotesListView.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import UIKit

final class NotesListView: UIView {
    
    var tableView: UITableView!
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        setupTableView()
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
