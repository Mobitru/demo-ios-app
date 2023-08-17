//
//  EmptyCartView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import UIKit
import SnapKit

final class EmptyCartView: UIView {
    // MARK: Variables
    private weak var imageView: UIImageView?
    private weak var titleLabel: UILabel?
    private weak var subtitleLabel: UILabel?
    weak var actionButton: UIButton?

    // MARK: Init and Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupActionButton()
    }

    private func setupImageView() {
        let imageView = UIImageView(image: UIImage(named: Constants.ImageView.imageName))
        imageView.tintColor = .oldPrice

        addSubview(imageView)
        self.imageView = imageView
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.text = Constants.TitleLabel.title
        label.textAlignment = .center
        label.font = .button
        label.textColor = .oldPrice
        label.accessibilityIdentifier = "emptyCartLabel"
        
        addSubview(label)
        self.titleLabel = label
    }

    private func setupSubtitleLabel() {
        let label = UILabel()
        label.text = Constants.SubtitleLabel.title
        label.textAlignment = .center
        label.font = .label
        label.textColor = .oldPrice
        label.numberOfLines = 0

        addSubview(label)
        self.subtitleLabel = label
    }

    private func setupActionButton() {
        let button = Button(.accent(title: Constants.Button.title))

        addSubview(button)
        self.actionButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let imageView, let titleLabel, let subtitleLabel else { return }

        imageView.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
            $0.size.equalTo(Constants.ImageView.size)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(Constants.TitleLabel.topOffset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
        }

        actionButton?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.Button.topOffset)
            $0.height.equalTo(Constants.Button.height)
            $0.width.equalTo(Constants.Button.width)
            $0.bottom.equalToSuperview()
        }
    }
}

private enum Constants {
    enum ImageView {
        static let imageName = "basket"
        static let size: CGFloat = 46
    }

    enum TitleLabel {
        static let title = "Cart is empty"
        static let topOffset: CGFloat = 12
    }

    enum SubtitleLabel {
        static let title = "There are no products added yet"
    }

    enum Button {
        static let title = "View products"
        static let topOffset: CGFloat = 24
        static let height: CGFloat = 48
        static let width: CGFloat = 147
    }
}
