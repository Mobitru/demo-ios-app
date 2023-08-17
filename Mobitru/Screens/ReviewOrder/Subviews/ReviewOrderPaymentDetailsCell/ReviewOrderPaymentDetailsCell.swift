//
//  ReviewOrderPaymentDetailsCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit

final class ReviewOrderPaymentDetailsCell: UITableViewCell {
    // MARK: Variables
    private weak var stackView: UIStackView?
    private weak var packagingFeeTitleLabel: UILabel?
    private weak var packagingFeeAmoutLabel: UILabel?
    private weak var subtotalTitleLabel: UILabel?
    private weak var subtotalAmoutLabel: UILabel?
    private weak var deliveryFeeTitleLabel: UILabel?
    private weak var deliveryFeeAmoutLabel: UILabel?
    private weak var discountTitleLabel: UILabel?
    private weak var discountAmoutLabel: UILabel?
    private weak var dividerView: UIView?
    private weak var totalTitleLabel: UILabel?
    private weak var totalAmoutLabel: UILabel?

    // MARK: Init and Deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func fill(with viewModel: ReviewOrderPaymentDetailsCellModel) {
        let format = Constants.moneyFormat
        packagingFeeAmoutLabel?.text = String(format: format, viewModel.packagingFee)
        subtotalAmoutLabel?.text = String(format: format, viewModel.subtotal)
        deliveryFeeAmoutLabel?.text = String(format: format, viewModel.deliveryFee)
        discountAmoutLabel?.text = String(format: format, viewModel.discount)
        totalAmoutLabel?.text = String(format: format, viewModel.total)
    }

    // MARK: Setup Views
    private func setupViews() {
        setupStackView()
        setupPackagingFeeLabels()
        setupSubtotalLabels()
        setupDeliveryFeeLabels()
        setupDiscountLabels()
        setupDeviderView()
        setupTotalLabels()
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constants.stackViewSpacing

        contentView.addSubview(stackView)
        self.stackView = stackView
    }

    private func setupPackagingFeeLabels() {
        let labels = setupTableRow(with: .sortingHeaderButton)
        labels.title.text = Constants.Titles.packagingFee
        self.packagingFeeTitleLabel = labels.title
        self.packagingFeeAmoutLabel = labels.amount
    }

    private func setupSubtotalLabels() {
        let labels = setupTableRow(with: .contactCellTitle)
        labels.title.text = Constants.Titles.subtotal
        self.subtotalTitleLabel = labels.title
        self.subtotalAmoutLabel = labels.amount
    }

    private func setupDeliveryFeeLabels() {
        let labels = setupTableRow(with: .sortingHeaderButton)
        labels.title.text = Constants.Titles.deliveryFee
        self.deliveryFeeTitleLabel = labels.title
        self.deliveryFeeAmoutLabel = labels.amount
    }

    private func setupDiscountLabels() {
        let labels = setupTableRow(with: .sortingHeaderButton)
        labels.title.text = Constants.Titles.discount
        self.discountTitleLabel = labels.title
        self.discountAmoutLabel = labels.amount
    }

    private func setupDeviderView() {
        let view = UIView()
        view.backgroundColor = .lightGray

        stackView?.addArrangedSubview(view)
        self.dividerView = view
    }

    private func setupTotalLabels() {
        let labels = setupTableRow(with: .contactCellTitle)
        labels.title.text = Constants.Titles.total
        self.totalTitleLabel = labels.title
        self.totalAmoutLabel = labels.amount
    }

    private func setupTableRow(with font: UIFont) -> (title: UILabel, amount: UILabel) {
        let stackView = setupSubStackView()
        let titleLabel = setupLabel(with: font)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.textAlignment = .left
        let amountLabel = setupLabel(with: font)
        amountLabel.textAlignment = .right

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(amountLabel)
        self.stackView?.addArrangedSubview(stackView)

        return (titleLabel, amountLabel)
    }

    private func setupSubStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }

    private func setupLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .buttonTint

        return label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        stackView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.stackViewInset)
        }

        dividerView?.snp.makeConstraints {
            $0.height.equalTo(Constants.dividerViewHeight)
        }
    }
}

private enum Constants {
    static let moneyFormat = "$ %.2f"
    static let stackViewSpacing: CGFloat = 4
    static let stackViewInset: CGFloat = 16
    static let dividerViewHeight: CGFloat = 1

    enum Titles {
        static let packagingFee = "Packaging fee"
        static let subtotal = "Subtotal"
        static let deliveryFee = "Delivery fee"
        static let discount = "Discount"
        static let total = "Total"
    }
}
