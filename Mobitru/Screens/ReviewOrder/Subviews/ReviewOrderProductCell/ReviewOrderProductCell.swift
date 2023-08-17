//
//  ReviewOrderProductCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit
import RxSwift

final class ReviewOrderProductCell: UITableViewCell {
    // MARK: Variables
    private weak var productImageView: UIImageView?
    private weak var viewHolder: UIView?
    private weak var titleLabel: UILabel?
    private weak var priceLabel: UILabel?
    private weak var oldPriceLabel: UILabel?
    private weak var discountLabel: UILabel?
    private weak var quantityLabel: UILabel?

    private(set) var disposeBag = DisposeBag()

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

        disposeBag = DisposeBag()
    }

    // MARK: Setup Views
    private func setupViews() {
        setupProductImageView()
        setupViewsHolder()
        setupPriceLabel()
        setupDiscountLabel()
        setupOldPriceLabel()
        setupTitleLabel()
        setupQuantityLabel()
    }

    private func setupProductImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "reviewOrderProductImage"

        contentView.addSubview(imageView)
        self.productImageView = imageView
    }

    private func setupViewsHolder() {
        let view = UIView()

        contentView.addSubview(view)
        self.viewHolder = view
    }

    private func setupPriceLabel() {
        let label = UILabel()
        label.font = .label
        label.textColor = .buttonTint
        label.accessibilityIdentifier = "reviewOrderProductPrice"

        viewHolder?.addSubview(label)
        self.priceLabel = label
    }

    private func setupDiscountLabel() {
        let label = UILabel()
        label.backgroundColor = .discountLabel
        label.textColor = .discountLabelText
        label.font = .discountLabelText
        label.layer.cornerRadius = Constants.DiscountLabel.cornerRadius
        label.accessibilityIdentifier = "reviewOrderProductDiscount"
        label.isHidden = true

        viewHolder?.addSubview(label)
        self.discountLabel = label
    }

    private func setupOldPriceLabel() {
        let label = UILabel()
        label.textColor = .oldPrice
        label.accessibilityIdentifier = "reviewOrderOldPrice"
        label.font = .oldPriceLabel
        label.isHidden = true

        viewHolder?.addSubview(label)
        self.oldPriceLabel = label
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.accessibilityIdentifier = "reviewOrderProductTitle"
        label.textColor = .buttonTint
        label.font = .sortingHeaderButton
        label.numberOfLines = 0

        viewHolder?.addSubview(label)
        self.titleLabel = label
    }

    private func setupQuantityLabel() {
        let label = UILabel()
        label.textColor = .oldPrice
        label.font = .sortingHeaderButton
        label.numberOfLines = 0

        viewHolder?.addSubview(label)
        self.quantityLabel = label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let productImageView,
              let viewHolder,
              let titleLabel,
              let priceLabel,
              let oldPriceLabel,
              let discountLabel,
              let quantityLabel
        else { return }

        productImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(Constants.ImageView.top)
            $0.height.width.equalTo(Constants.ImageView.height)
        }

        viewHolder.snp.makeConstraints {
            $0.leading.equalTo(productImageView.snp.trailing).offset(Constants.ViewHolder.leading)
            $0.centerY.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(Constants.ViewHolder.top)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.PriceLabel.top)
            $0.leading.bottom.equalToSuperview()
        }

        oldPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.trailing).offset(Constants.OldPriceLabel.leading)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }

        discountLabel.snp.makeConstraints {
            $0.leading.equalTo(oldPriceLabel.snp.trailing).offset(Constants.DiscountLabel.leading)
            $0.centerY.equalTo(priceLabel.snp.centerY)
        }

        quantityLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel.snp.centerY)
            $0.leading.greaterThanOrEqualTo(discountLabel.snp.trailing).offset(Constants.QuantityLabel.leading)
            $0.trailing.equalToSuperview()
        }
    }

    // MARK: - Public Methods
    func fill(with viewModel: ReviewOrderProductCellModel) {
        productImageView?.image = UIImage(named: viewModel.imageName)
        titleLabel?.text = viewModel.productTitle
        priceLabel?.text = viewModel.price.usdPriceString
        quantityLabel?.text = String(format: Constants.QuantityLabel.title, viewModel.count)
        oldPriceLabel?.isHidden = !viewModel.hasDiscount
        discountLabel?.isHidden = !viewModel.hasDiscount
        discountLabel?.text = viewModel.discount
        fillOldPriceLabel(price: viewModel.oldPrice)
        updatePriceLabelAppearance(hasDiscount: viewModel.hasDiscount)
    }

    // MARK: - Private Methods
    private func updatePriceLabelAppearance(hasDiscount: Bool) {
        priceLabel?.textColor = hasDiscount ? .discountedPrice : .buttonTint
    }

    private func fillOldPriceLabel(price: Int?) {
        guard let price else {
            oldPriceLabel?.text = nil

            return
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2

        oldPriceLabel?.attributedText = NSMutableAttributedString(
            string: price.usdPriceString,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}

private enum Constants {
    enum ImageView {
        static let top: CGFloat = 16
        static let height: CGFloat = 56
    }

    enum ViewHolder {
        static let leading: CGFloat = 16
        static let top: CGFloat = 16
    }

    enum PriceLabel {
        static let top: CGFloat = 4
    }

    enum OldPriceLabel {
        static let leading: CGFloat = 4
    }

    enum DiscountLabel {
        static let cornerRadius: CGFloat = 4
        static let leading: CGFloat = 16
    }

    enum QuantityLabel {
        static let leading: CGFloat = 16
        static let title = "Qty: %d"
    }
}
