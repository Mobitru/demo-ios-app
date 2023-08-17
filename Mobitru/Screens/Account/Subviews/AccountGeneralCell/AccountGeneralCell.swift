//
//  AccountGeneralCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class AccountGeneralCell: UITableViewCell {
    // MARK: Variables
    private weak var titleLabel: UILabel?
    private let tapGesture = UITapGestureRecognizer()
    private(set) var disposeBag = DisposeBag()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func fill(with viewModel: AccountGeneralCellViewModel) {
        titleLabel?.text = viewModel.title
        disposeBag = DisposeBag()
        contentView.rx.tapGesture()
            .filter { $0.state == .recognized }
            .map { _ in () }
            .bind(to: viewModel.didTap)
            .disposed(by: disposeBag)
    }

    // MARK: Setup Views
    private func setupViews() {
        let label = UILabel()
        label.font = .label
        label.textColor = .buttonTint
        label.addGestureRecognizer(tapGesture)

        contentView.addSubview(label)
        titleLabel = label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        titleLabel?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
