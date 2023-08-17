//
//  CartCounterView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.01.23.
//

import UIKit

final class CartCounterView: UIView {
    // MARK: Variables
    private weak var textLabel: UILabel?

    // MARK: Init and Deinit
    init(_ viewModel: CartCounterViewModel) {
        super.init(frame: .zero)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        layer.backgroundColor = UIColor.cartCounterLabel.cgColor
        layer.cornerRadius = Constants.cornerRadius

        setupTextLabel()
    }

    private func setupTextLabel() {
        let label = UILabel()
        label.font = .button
        label.textColor = .tabBarItemTint
        label.numberOfLines = 1
        label.accessibilityIdentifier =  "cartCounter"

        addSubview(label)
        self.textLabel = label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        textLabel?.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
        }
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 8
}
