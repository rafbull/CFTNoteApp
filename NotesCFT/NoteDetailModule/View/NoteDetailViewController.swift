//
//  NoteDetailViewController.swift
//  NotesCFT
//
//  Created by Rafis on 04.03.2024.
//

import UIKit
import Combine

final class NoteDetailViewController: UIViewController {
    
    var noteIndex: Int?
    var editNoteRequest: ((_ selectedNote: Note, _ index: Int) -> Void)?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func loadView() {
        view = contentView
    }
    
    // MARK: - Private Properties
    var viewModel: NoteDetailViewModelProtocol? {
        didSet {
            sinkToViewModel()
        }
    }
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var contentView: NoteDetailView = {
        let contentView = NoteDetailView()
        contentView.noteTextView.delegate = self
        return contentView
    }()
    
    // MARK: - Private Methods
    private func sinkToViewModel() {

        guard let viewModel = viewModel else { return }

        viewModel.noteTitle
            .combineLatest(viewModel.noteText, viewModel.noteDate)
            .sink { [weak self] (title, text, _) in
                self?.contentView.noteTextView.text = title + "\n" + text
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        
        // Scrolling TextView to the top
        contentView.scrollToTop(false)
    }
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        contentView.noteTextView.resignFirstResponder()
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let viewModel = viewModel, let noteIndex = noteIndex else { return }
        // Note is not created if no character is entered
        guard textView.text != "\n" else { return }
        
        viewModel.updateNote(with: textView.text, and: Date())
        
        editNoteRequest?(viewModel.updatedNote, noteIndex)
    }
}
