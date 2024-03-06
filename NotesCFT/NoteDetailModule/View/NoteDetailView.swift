//
//  NoteDetailView.swift
//  NotesCFT
//
//  Created by Rafis on 04.03.2024.
//

import UIKit

final class NoteDetailView: UIView {
    
    var noteTextView: UITextView!
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        setupNoteTextView()
        setupUI()
        setConstraints()
        subscribeToKeyboardNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let noteTextFontSize: CGFloat = 20
        static let noteTitleFontSize: CGFloat = 23
        static let noteTextViewContentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
    
    // MARK: - Private Properties
    private var noteTextViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Public Methods
    public func scrollToTop(_ animated: Bool) {
        noteTextView.setContentOffset(.zero, animated: animated)
    }
    
    // MARK: - Private Methods
    private func setupNoteTextView() {
        noteTextView = UITextView()
        noteTextView.font = .systemFont(ofSize: UIConstants.noteTextFontSize)
        noteTextView.backgroundColor = .systemBackground
        noteTextView.textColor = .label
        noteTextView.keyboardDismissMode = .onDrag
        noteTextView.verticalScrollIndicatorInsets = .zero
        noteTextView.contentInset = UIConstants.noteTextViewContentInset
        noteTextView.scrollsToTop = true
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(noteTextView)
    }
    
    private func setConstraints() {
        guard let noteTextView = noteTextView else { return }

        noteTextViewBottomConstraint = .init(
            item: noteTextView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noteTextView.topAnchor.constraint(equalTo: topAnchor),
            noteTextViewBottomConstraint!
        ])
    }
    
    private func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateNoteTextView),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateNoteTextView),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func updateNoteTextView(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = UIConstants.noteTextViewContentInset
            noteTextView.verticalScrollIndicatorInsets = .zero
        } else {
            noteTextView.contentInset.bottom = keyboardFrame.height - (noteTextViewBottomConstraint?.constant ?? 0)
            noteTextView.verticalScrollIndicatorInsets = .zero
        }
    }
    
    func setAttributedString(for title: String, and text: String) {
        let noteTitleAndText = title + text

        let attributedString = NSMutableAttributedString(string: noteTitleAndText)
        let range = NSRange(location: .zero, length: title.count)

        attributedString.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.boldSystemFont(ofSize: UIConstants.noteTitleFontSize),
            range: range)
        noteTextView.attributedText = attributedString
    }
}
