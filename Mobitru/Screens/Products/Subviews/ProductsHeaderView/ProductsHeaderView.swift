//
//  ProductsHeaderView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.01.23.
//

import UIKit

final class ProductsHeaderView: UIView {
    // MARK: Variables
    private weak var textLabel: UILabel?
    weak var sortingView: ProductsSortingIndicatorView?
    weak var sortingViewModel: ProductsSortingIndicatorViewModel?

    // MARK: Init and Deinit
    init(sortingViewModel: ProductsSortingIndicatorViewModel) {
        self.sortingViewModel = sortingViewModel

        super.init(frame: .zero)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        setupTextLabel()
        setupSortingView()
    }

    private func setupTextLabel() {
        let label = UILabel()
        label.font = .button
        label.textColor = .tabBarItemTint
        label.numberOfLines = 1
        label.accessibilityIdentifier = "productHeaderViewLabel"
        
        addSubview(label)
        self.textLabel = label
    }

    private func setupSortingView() {
        guard let sortingViewModel else { return }

        let view = ProductsSortingIndicatorView(viewModel: sortingViewModel)

        addSubview(view)
        self.sortingView = view
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let textLabel else { return }

        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Constants.Label.leading)
        }

        sortingView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(textLabel.snp.trailing).offset(Constants.SortingView.leading)
            $0.trailing.equalToSuperview().inset(Constants.SortingView.trailing)
        }
    }

    // MARK: - Public Methods
    func fill(with count: Int) {
        textLabel?.text = String(format: Constants.Label.title, count)
    }
}

private enum Constants {
    enum Label {
        static let leading: CGFloat = 16
        static let title = "Mobile phones (%d)"
    }

    enum SortingView {
        static let leading: CGFloat = 8
        static let trailing: CGFloat = 16
    }
}
