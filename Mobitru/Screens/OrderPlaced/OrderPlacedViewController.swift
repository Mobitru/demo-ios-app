//
//  OrderPlacedViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 03.02.23.
//

import UIKit

final class OrderPlacedViewController: UIViewController {
    // MARK: Variables
    private weak var contentView: UIView?
    private weak var imageView: UIImageView?
    private weak var titleLabel: UILabel?
    private weak var actionButton: UIButton?

    private let viewModel: OrderPlacedViewModel

    // MARK: Init and Deinit
    init(_ viewModel: OrderPlacedViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.onControllerDeinit.onNext(())
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        title = Constants.title
        navigationItem.hidesBackButton = true

        setupContentView()
        setupImageView()
        setupTitleLabel()
        setupActionButton()
    }

    private func setupContentView() {
        let contentView = UIView()

        view.addSubview(contentView)
        self.contentView = contentView
    }

    private func setupImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageView.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .promoAppliedText

        contentView?.addSubview(imageView)
        self.imageView = imageView
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.text = Constants.TitleLabel.title
        label.textColor = .buttonTint
        label.font = .orderPlacedLabel
        label.textAlignment = .center
        label.numberOfLines = 0

        contentView?.addSubview(label)
        self.titleLabel = label
    }

    private func setupActionButton() {
        let button = Button(.signIn)
        button.setTitle(Constants.ActionButton.title, for: .normal)
        button.addTarget(nil, action: #selector(onActionButton), for: .touchUpInside)

        view.addSubview(button)
        self.actionButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let contentView, let imageView else { return }

        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.ContentView.horizontalInset)
        }

        imageView.snp.makeConstraints {
            $0.centerX.top.equalToSuperview()
            $0.size.equalTo(Constants.ImageView.size)
        }

        titleLabel?.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(Constants.TitleLabel.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        actionButton?.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.ActionButton.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.ActionButton.bottom)
            $0.height.equalTo(Constants.ActionButton.height)
        }
    }

    // MARK: Actions
    @objc private func onActionButton() {
        viewModel.didTapGoBack.onNext(())
    }
}

private enum Constants {
    static let title = "Order completed"

    enum ContentView {
        static let horizontalInset: CGFloat = 16
    }

    enum ImageView {
        static let imageName = "done"
        static let size: CGFloat = 72
    }

    enum TitleLabel {
        static let title = "Order successfully placed. Please check your email."
        static let top: CGFloat = 16
    }

    enum ActionButton {
        static let title = "Go back to products"
        static let horizontalInset: CGFloat = 16
        static let bottom: CGFloat = 16
        static let height: CGFloat = 48
    }

}
