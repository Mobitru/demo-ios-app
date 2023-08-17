//
//  ProductCollectionViewCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 25.01.23.
//

import UIKit
import RxSwift

final class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: Variables
    private weak var imageView: UIImageView?
    private weak var priceLabel: UILabel?
    private weak var oldPriceLabel: UILabel?
    private weak var titleLabel: UILabel?
    private(set) weak var addButton: UIButton?
    private weak var discountLabel: UILabel?

    private(set) var disposeBag = DisposeBag()

    // MARK: Init and Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)

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
        setupPriceLabel()
        setupDiscountLabel()
        setupOldPriceLabel()
        setupTitleLabel()
        setupAddButton()
        prepareAccessibility()
    }

    private func setupProductImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = Constants.ImageView.accessibilityLabel

        addSubview(imageView)
        self.imageView = imageView
    }

    private func setupPriceLabel() {
        let label = UILabel()
        label.font = .priceLabel

        addSubview(label)
        self.priceLabel = label
    }

    private func setupDiscountLabel() {
        let label = UILabel()
        label.backgroundColor = .discountLabel
        label.textColor = .discountLabelText
        label.font = .discountLabelText
        label.layer.cornerRadius = Constants.DiscountLabel.cornerRadius
        label.isHidden = true

        addSubview(label)
        self.discountLabel = label
    }

    private func setupOldPriceLabel() {
        let label = UILabel()
        label.textColor = .oldPrice
        label.font = .oldPriceLabel
        label.isHidden = true

        addSubview(label)
        self.oldPriceLabel = label
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .buttonTint
        label.font = .sortingHeaderButton
        label.numberOfLines = Constants.TitleLabel.numberOfLines

        addSubview(label)
        self.titleLabel = label
    }

    private func setupAddButton() {
        let button = UIButton()
        button.layer.cornerRadius = Constants.AddButton.cornerRadius
        button.titleLabel?.font = .button

        addSubview(button)
        self.addButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let imageView, let priceLabel, let titleLabel else { return }

        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.equalToSuperview()
        }

        discountLabel?.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.top).offset(Constants.DiscountLabel.bottomOffset)
            $0.leading.equalTo(priceLabel.snp.leading)
        }

        oldPriceLabel?.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.bottom).offset(Constants.OldPriceLabel.bottomOffset)
            $0.leading.equalTo(priceLabel.snp.trailing).offset(Constants.OldPriceLabel.leading)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(Constants.TitleLabel.topOffset)
            $0.leading.trailing.equalToSuperview()
        }

        addButton?.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(Constants.AddButton.topOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.AddButton.height)
        }
    }

    // MARK: - Private Methods
    private func updateButtonAppearance(_ state: AddToCartButtonState, itemName: String) {
        typealias C = Constants.AddButton
        let button = addButton
        switch state {
        case .notAdded:
            button?.setTitle(C.titleAdd, for: .normal)
            button?.setTitleColor(.accentButtonTint, for: .normal)
            button?.backgroundColor = .accentButton
            button?.layer.borderWidth = 0
            button?.accessibilityLabel = C.accessibilityLabelAdd
            button?.accessibilityHint = String(format: C.accessibilityHintAdd, itemName)
        case .added:
            button?.setTitle(C.titleAdded, for: .normal)
            button?.setTitleColor(.buttonTint, for: .normal)
            button?.backgroundColor = .button
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.bordersColor.cgColor
            button?.accessibilityLabel = C.accessibilityLabelAdded
            button?.accessibilityHint = String(format: C.accessibilityHintAdded, itemName)
        }
    }

    private func updatePriceLabelAppearance(hasDiscount: Bool) {
        priceLabel?.textColor = hasDiscount ? .discountedPrice : .buttonTint
    }

    private func fillOldPriceLabel(price: Int) {
        let oldPriceLabel = self.oldPriceLabel
        let priceString = price.usdPriceString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        oldPriceLabel?.attributedText = NSMutableAttributedString(
            string: priceString,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .paragraphStyle: paragraphStyle
            ]
        )
        oldPriceLabel?.accessibilityLabel = Constants.OldPriceLabel.accessibilityLabel + priceString
    }

    // MARK: - Public Methods
    func fill(with viewModel: ProductCollectionViewModel) {
        imageView?.image = UIImage(named: viewModel.imageName)
        imageView?.accessibilityIdentifier = "productImage"
        
        let titleLabel = self.titleLabel
        let title = viewModel.productTitle
        titleLabel?.text = title
        titleLabel?.accessibilityIdentifier = "productTitle"
        titleLabel?.accessibilityLabel = title

        let priceLabel = self.priceLabel
        let price = viewModel.price.usdPriceString
        priceLabel?.text = price
        priceLabel?.accessibilityIdentifier = "productPrice"
        priceLabel?.accessibilityLabel = price

        let oldPriceLabel = self.oldPriceLabel
        oldPriceLabel?.isHidden = !viewModel.hasDiscount
        oldPriceLabel?.accessibilityIdentifier = "oldProductPrice"
        oldPriceLabel?.isAccessibilityElement = viewModel.hasDiscount

        let discountLabel = self.discountLabel
        discountLabel?.isHidden = !viewModel.hasDiscount
        discountLabel?.accessibilityIdentifier = "discountPrice"
        discountLabel?.isAccessibilityElement = viewModel.hasDiscount
        if viewModel.hasDiscount, let discount = viewModel.discount {
            discountLabel?.text = discount
            discountLabel?.accessibilityLabel = String(format: Constants.DiscountLabel.accessibilityLabel, discount)
            viewModel.oldPrice.map(fillOldPriceLabel(price:))
        }

        updateButtonAppearance(viewModel.buttonState, itemName: title)
        updatePriceLabelAppearance(hasDiscount: viewModel.hasDiscount)
    }
}

extension ProductCollectionViewCell {
    private func prepareAccessibility() {
        accessibilityElements = [
            imageView,
            titleLabel,
            discountLabel,
            priceLabel,
            oldPriceLabel,
            addButton
        ].compactMap { $0 as Any }
    }
}

private enum Constants {
    enum ImageView {
        static let accessibilityLabel = "Phone image"
    }

    enum DiscountLabel {
        static let cornerRadius: CGFloat = 4
        static let bottomOffset: CGFloat = -4
        static let accessibilityLabel = "Discount %d"
    }

    enum TitleLabel {
        static let numberOfLines = 2
        static let topOffset: CGFloat = 4
    }

    enum AddButton {
        static let cornerRadius: CGFloat = 6
        static let topOffset: CGFloat = 12
        static let height: CGFloat = 32

        static let titleAdd = "Add to cart"
        static let accessibilityLabelAdd = "Add to cart"
        static let accessibilityHintAdd = "Activate to add %@ to cart"

        static let titleAdded = "Added to cart"
        static let accessibilityLabelAdded = "Added to cart"
        static let accessibilityHintAdded = "Activate to remove %@ from cart"
    }

    enum OldPriceLabel {
        static let bottomOffset: CGFloat = -2
        static let leading: CGFloat = 4
        static let accessibilityLabel = "Price before discount "
    }
}
