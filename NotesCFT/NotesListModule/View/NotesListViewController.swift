//
//  ViewController.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import UIKit
import Combine

final class NotesListViewController: UIViewController {
    
    var showDetailNoteRequest: ((_ selectedNote: Note?, _ index: Int?) -> Void)?
    var createNewNote: (() -> Void)?

    // MARK: Initialization
    init(viewModel: NotesListViewModelProtocol = NotesListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createDataSource()
        
        viewModel.createDefaultNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.notes
            .sink { [weak self] _ in
                self?.applySnapshot()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private Properties
    private let viewModel: NotesListViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var contentView: NotesListView = {
        let contentView = NotesListView()
        contentView.tableView.delegate = self
        return contentView
    }()
    
    private var dataSource: NotesListTableViewDiffableDataSource!
    private typealias Snapshot = NSDiffableDataSourceSnapshot<NotesListTableViewSections, Note>
    
    
    // MARK: - Private Methods
    // Creating Data Source
    private func createDataSource() {
        dataSource = NotesListTableViewDiffableDataSource(tableView: contentView.tableView, cellProvider: { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell
            cell?.viewModel = NoteCellViewModel(note: note)
            return cell
        })
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.listSection])
        snapshot.appendItems(viewModel.notes.value, toSection: .listSection)

        updateViewModel()

        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func updateViewModel() {
        dataSource.deleteNoteFromViewModel = { [weak self] index in
            self?.viewModel.deleteNote(at: index)
        }
    }
    
    private func setupUI() {
        title = "NotesCFT"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapPlusButton))
    }
    
    @objc private func didTapPlusButton() {
        createNewNote?()
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedNote = dataSource.itemIdentifier(for: indexPath) else { return }
        
        showDetailNoteRequest?(selectedNote, indexPath.row)
    }
}


