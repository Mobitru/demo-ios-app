//
//  LoginErrorView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 19.01.23.
//

import UIKit

final class LoginErrorView: UIView {
    // MARK: Variables
    private weak var imageView: UIImageView?
    private weak var textLabel: UILabel?
    private(set) weak var closeButton: UIButton?

    // MARK: Init and Deinit
    init() {
        super.init(frame: .zero)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        layer.backgroundColor = UIColor.errorMessageBackground.cgColor
        layer.cornerRadius = Constants.cornerRadius

        setupImageView()
        setupTextLabel()
        setupCloseButton()
    }

    private func setupImageView() {
        let view = UIImageView()
        view.image = UIImage(named: Constants.ImageView.name)
        view.sizeToFit()
        view.tintColor = .errorMessage

        addSubview(view)
        self.imageView = view
    }

    private func setupTextLabel() {
        let label = UILabel()
        label.text = Constants.Label.title
        label.textColor = .errorMessage
        label.font = .label
        label.numberOfLines = 1
        label.accessibilityIdentifier = "errorMessage"

        addSubview(label)
        self.textLabel = label
    }

    private func setupCloseButton() {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.Button.name), for: .normal)
        button.tintColor = .errorMessage

        addSubview(button)
        self.closeButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let imageView, let textLabel else { return }

        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.ImageView.verticalInset)
            $0.leading.equalToSuperview().offset(Constants.ImageView.horizontalInset)
            $0.size.equalTo(Constants.ImageView.size)
        }

        textLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(Constants.Label.leading)
        }

        closeButton?.snp.makeConstraints {
            $0.centerY.equalTo(textLabel)
            $0.leading.greaterThanOrEqualTo(textLabel.snp.trailing).offset(Constants.Button.leading)
            $0.trailing.equalToSuperview().inset(Constants.Button.trailing)
            $0.size.equalTo(Constants.Button.size)
        }
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 8

    enum ImageView {
        static let name = "loginError"
        static let verticalInset: CGFloat = 14
        static let horizontalInset: CGFloat = 16
        static let size: CGFloat = 24
    }

    enum Label {
        static let title = "Incorrect email or password"
        static let leading: CGFloat = 8
    }

    enum Button {
        static let name = "loginErrorClose"
        static let leading: CGFloat = 8
        static let trailing: CGFloat = 16
        static let size: CGFloat = 16
    }
}
