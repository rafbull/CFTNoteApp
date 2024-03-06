//
//  NoteTableViewCell.swift
//  NotesCFT
//
//  Created by Rafis on 01.03.2024.
//

import UIKit
import Combine

class NoteTableViewCell: UITableViewCell {
    
    static let identifier = "NoteTableViewCell"
    
    var viewModel: NoteCellViewModelProtocol? {
        didSet {
            sinkToViewModel()
        }
    }
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let noteTitleLabelFontSize: CGFloat = 17
        static let noteDateLabelFontSize: CGFloat = 14
        static let noteTextLabelFontSize: CGFloat = 14
        static let hStackViewSpacing: CGFloat = 8
    }
    
    // MARK: - Private Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var noteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.noteTitleLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noteDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.noteDateLabelFontSize, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noteTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.noteTextLabelFontSize, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noteDateLabel, noteTextLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIConstants.hStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Private Methods
    private func sinkToViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.noteTitle
            .combineLatest(viewModel.noteDate, viewModel.noteText)
            .sink { [weak self] (title, date, text) in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yy"
                
                self?.noteDateLabel.text = formatter.string(from: date)
                self?.noteTitleLabel.text = title
                self?.noteTextLabel.text = text
            }
            .store(in: &subscriptions)
    }
    
    private func setupUI() {
        contentView.addSubview(noteTitleLabel)
        contentView.addSubview(hStackView)
    }
    
    private func setConstraints() {
        let contentViewMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            noteTitleLabel.topAnchor.constraint(equalTo: contentViewMargins.topAnchor),
            noteTitleLabel.leadingAnchor.constraint(equalTo: contentViewMargins.leadingAnchor),
            noteTitleLabel.trailingAnchor.constraint(equalTo: contentViewMargins.trailingAnchor),
            
            hStackView.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: contentViewMargins.leadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: contentViewMargins.trailingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: contentViewMargins.bottomAnchor),
        ])
    }
}
