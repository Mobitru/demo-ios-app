//
//  OrderCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.02.23.
//

import UIKit

final class OrderCell: UITableViewCell {
    // MARK: Variables
    private weak var stackView: UIStackView?
    private weak var stateStackView: UIStackView?
    private weak var stateLabel: UILabel?
    private weak var labelsStackView: UIStackView?
    private weak var titleLabel: UILabel?
    private weak var priceLabel: UILabel?
    private weak var itemsStackView: UIStackView?

    // MARK: Init and Deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        itemsStackView?.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }

    // MARK: - Public Methods
    func fill(with viewModel: OrderCellModel) {
        stateStackView?.isHidden = !viewModel.isInProgress
        titleLabel?.text = viewModel.title
        priceLabel?.text = viewModel.price
        viewModel.items.forEach(self.addItem)
    }

    // MARK: Setup Views
    private func setupViews() {
        setupStackView()
        setupStateView()
        setupLabelsStackView()
        setupTitleLabel()
        setupPriceLabel()
        setupItemsStackView()
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.stackViewSpacing

        contentView.addSubview(stackView)
        self.stackView = stackView
    }

    private func setupStateView() {
        let containerView = UIView()
        containerView.backgroundColor = .promoAppliedText
        containerView.layer.cornerRadius = Constants.stateViewCornerRadius

        let label = UILabel()
        label.text = Constants.stateLabelTitle
        label.font = .orderState
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        containerView.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.stateViewInset)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(UIView())

        self.stackView?.addArrangedSubview(stackView)
        self.stateStackView = stackView
        self.stateLabel = label
    }

    private func setupLabelsStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.stackViewSpacing

        self.stackView?.addArrangedSubview(stackView)
        self.labelsStackView = stackView
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .buttonTint
        label.font = .button

        self.labelsStackView?.addArrangedSubview(label)
        self.titleLabel = label
    }

    private func setupPriceLabel() {
        let label = UILabel()
        label.textColor = .buttonTint
        label.font = .button
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        self.labelsStackView?.addArrangedSubview(label)
        self.priceLabel = label
    }

    private func setupItemsStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.stackViewSpacing

        self.stackView?.addArrangedSubview(stackView)
        self.itemsStackView = stackView
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        stackView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.stackViewInset)
        }
    }

    // MARK: - Private Methods
    private func addItem(title: String, count: Int) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.itemsStackView?.addArrangedSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = title
        stackView.addArrangedSubview(titleLabel)

        let countLabel = UILabel()
        countLabel.text = String(format: Constants.countLabelTitle, count)
        countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(countLabel)
    }
}

private enum Constants {
    static let countLabelTitle = "x%d"
    static let stateLabelTitle = "In progress"
    static let stackViewSpacing: CGFloat = 4
    static let stackViewInset: CGFloat = 16
    static let stateViewInset: CGFloat = 4
    static let stateViewCornerRadius: CGFloat = 4
}
