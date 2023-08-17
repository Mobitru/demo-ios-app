//
//  CartTableViewCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import Foundation
import UIKit
import RxSwift

final class CartTableViewCell: UITableViewCell {
    // MARK: Variables
    private weak var productImageView: UIImageView?
    private weak var titleLabel: UILabel?
    private weak var priceLabel: UILabel?
    private weak var oldPriceLabel: UILabel?
    private weak var discountLabel: UILabel?
    private weak var countTextField: UITextField?
    private(set) weak var plusButton: UIButton?
    private(set) weak var minusButton: UIButton?

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
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let plusButton, let minusButton else { return }

        plusButton.layer.cornerRadius = plusButton.layer.frame.size.height / 2
        minusButton.layer.cornerRadius = minusButton.layer.frame.size.height / 2
    }

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
        setupPlusButton()
        setupMinusButton()
        setupCountTextField()
    }

    private func setupProductImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "cartProductImage"
        
        contentView.addSubview(imageView)
        self.productImageView = imageView
    }

    private func setupPriceLabel() {
        let label = UILabel()
        label.font = .label
        label.textColor = .buttonTint
        label.accessibilityIdentifier = "cartProductPrice"
        
        contentView.addSubview(label)
        self.priceLabel = label
    }

    private func setupDiscountLabel() {
        let label = UILabel()
        label.backgroundColor = .discountLabel
        label.textColor = .discountLabelText
        label.font = .discountLabelText
        label.layer.cornerRadius = Constants.DiscountLabel.cornerRadius
        label.isHidden = true
        label.accessibilityIdentifier = "cartProductDiscount"
        

        contentView.addSubview(label)
        self.discountLabel = label
    }

    private func setupOldPriceLabel() {
        let label = UILabel()
        label.textColor = .oldPrice
        label.font = .oldPriceLabel
        label.isHidden = true
        label.accessibilityIdentifier = "cartProductOldPrice"

        contentView.addSubview(label)
        self.oldPriceLabel = label
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.textColor = .buttonTint
        label.font = .sortingHeaderButton
        label.numberOfLines = 0
        label.accessibilityIdentifier = "cartProductTitle"

        contentView.addSubview(label)
        self.titleLabel = label
    }

    private func setupPlusButton() {
        let button = setupRoundButton()
        button.setTitle(Constants.RoundButton.plusTitle, for: .normal)

        contentView.addSubview(button)
        self.plusButton = button
    }

    private func setupMinusButton() {
        let button = setupRoundButton()
        button.setTitle(Constants.RoundButton.minusTitle, for: .normal)

        contentView.addSubview(button)
        self.minusButton = button
    }

    private func setupRoundButton() -> UIButton {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = Constants.RoundButton.borderWidth
        button.layer.masksToBounds = true
        button.tintColor = .buttonTint
        button.setTitleColor(.buttonTint, for: .normal)
        button.setTitleColor(.oldPrice, for: .disabled)
        button.titleLabel?.font = .button

        return button
    }

    private func setupCountTextField() {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        textField.textColor = .buttonTint
        textField.font = .sortingHeaderButton
        textField.layer.borderWidth = Constants.TextField.borderWidth
        textField.layer.cornerRadius = Constants.TextField.cornerRadius
        textField.layer.borderColor = UIColor.bordersColor.cgColor

        contentView.addSubview(textField)
        self.countTextField = textField
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let productImageView, let minusButton, let countTextField, let plusButton, let priceLabel else { return }

        productImageView.snp.makeConstraints {
            typealias C = Constants.ImageView
            $0.top.equalToSuperview().inset(C.top)
            $0.leading.equalToSuperview().inset(C.leading)
            $0.size.equalTo(C.size)
        }

        titleLabel?.snp.makeConstraints {
            typealias C = Constants.TitleLabel
            $0.centerY.equalTo(productImageView.snp.centerY)
            $0.leading.equalTo(productImageView.snp.trailing).offset(C.leading)
            $0.trailing.equalToSuperview().inset(C.trailing)
        }

        minusButton.snp.makeConstraints {
            typealias C = Constants.RoundButton.Minus
            $0.top.equalTo(productImageView.snp.bottom).offset(C.top)
            $0.leading.bottom.equalToSuperview().offset(Constants.RoundButton.leading)
            $0.size.equalTo(C.size)
            $0.bottom.equalToSuperview().inset(C.bottom)
        }

        countTextField.snp.makeConstraints {
            typealias C = Constants.TextField
            $0.centerY.equalTo(minusButton.snp.centerY)
            $0.leading.equalTo(minusButton.snp.trailing).offset(C.leading)
            $0.height.equalTo(minusButton.snp.height)
            $0.width.equalTo(C.width)
        }

        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(minusButton.snp.centerY)
            $0.leading.equalTo(countTextField.snp.trailing).offset(Constants.RoundButton.leading)
            $0.height.width.equalTo(minusButton.snp.height)
        }

        priceLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(plusButton.snp.trailing)
            $0.bottom.equalTo(minusButton.snp.bottom)
        }

        oldPriceLabel?.snp.makeConstraints {
            typealias C = Constants.OldPriceLabel
            $0.leading.equalTo(priceLabel.snp.trailing).offset(C.leading)
            $0.bottom.equalTo(priceLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(C.trailing)
        }

        discountLabel?.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel.snp.top)
            $0.trailing.equalToSuperview().inset(Constants.DiscountLabel.trailing)
        }
    }

    // MARK: - Public Methods
    func fill(with viewModel: CartTableViewCellViewModel) {
        productImageView?.image = UIImage(named: viewModel.imageName)
        titleLabel?.text = viewModel.productTitle
        priceLabel?.text = viewModel.price.usdPriceString
        countTextField?.text = String(viewModel.count)
        oldPriceLabel?.isHidden = !viewModel.hasDiscount
        discountLabel?.isHidden = !viewModel.hasDiscount
        discountLabel?.text = viewModel.discount
        fillOldPriceLabel(price: viewModel.oldPrice)
        plusButton?.isEnabled = viewModel.canAddItems
        updateMinusButtonAppearance(viewModel.minusButtonState)
        updatePriceLabelAppearance(hasDiscount: viewModel.hasDiscount)
    }

    // MARK: - Private Methods
    private func updateMinusButtonAppearance(_ state: MinusButtonState) {
        typealias C = Constants.RoundButton
        let button = minusButton
        switch state {
        case .minus:
            button?.setTitle(C.minusTitle, for: .normal)
            button?.setImage(nil, for: .normal)
        case .delete:
            button?.setTitle("", for: .normal)
            button?.setImage(UIImage(named: C.deleteImageName), for: .normal)
        }
    }

    private func updatePriceLabelAppearance(hasDiscount: Bool) {
        priceLabel?.textColor = hasDiscount ? .discountedPrice : .buttonTint
    }

    private func fillOldPriceLabel(price: Int?) {
        guard let price else {
            oldPriceLabel?.text = nil

            return
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.OldPriceLabel.lineHeight

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
        static let leading: CGFloat = 2
        static let size: CGFloat = 128
    }

    enum TitleLabel {
        static let leading: CGFloat = 2
        static let trailing: CGFloat = 16
    }

    enum OldPriceLabel {
        static let leading: CGFloat = 4
        static let trailing: CGFloat = 16
        static let lineHeight: CGFloat = 1.2
    }

    enum DiscountLabel {
        static let cornerRadius: CGFloat = 4
        static let trailing: CGFloat = 16
    }

    enum RoundButton {
        static let plusTitle = "+"
        static let minusTitle = "-"
        static let deleteImageName = "trash"
        static let borderWidth: CGFloat = 1
        static let leading: CGFloat = 16

        enum Minus {
            static let top: CGFloat = 2
            static let size: CGFloat = 40
            static let bottom: CGFloat = 16
        }
    }

    enum TextField {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let leading: CGFloat = 16
        static let width: CGFloat = 69
    }
}
