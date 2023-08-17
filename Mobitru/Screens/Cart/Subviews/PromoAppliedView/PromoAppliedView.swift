//
//  PromoAppliedView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import UIKit
import SnapKit

final class PromoAppliedView: UIView {
    // MARK: Variables
    private weak var titleLabel: UILabel?
    private(set) weak var deleteButton: UIButton?

    // MARK: Init and Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func fill(with promo: String?) {
        titleLabel?.text = promo.map { $0 + Constants.Label.applied }
    }

    // MARK: Setup Views
    private func setupViews() {
        setupTitleLabel()
        setupDeleteButton()
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.font = .label
        label.textColor = .promoAppliedText

        addSubview(label)
        self.titleLabel = label
    }

    private func setupDeleteButton() {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Button.imageName), for: .normal)
        button.tintColor = .buttonTint

        addSubview(button)
        self.deleteButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let titleLabel else { return }

        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }

        deleteButton?.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(Constants.Button.leading)
            $0.centerY.trailing.equalToSuperview()
        }
    }
}

private enum Constants {
    enum Label {
        static let applied = " applied"
    }

    enum Button {
        static let imageName = "trash"
        static let leading: CGFloat = 8
    }
}
