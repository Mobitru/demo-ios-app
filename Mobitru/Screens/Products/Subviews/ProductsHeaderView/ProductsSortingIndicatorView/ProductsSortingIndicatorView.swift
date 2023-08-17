//
//  ProductsSortingIndicatorView.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.01.23.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductsSortingIndicatorView: UIView {
    // MARK: Variables
    private weak var imageView: UIImageView?
    private weak var arrowView: UIImageView?
    private weak var textLabel: UILabel?

    private weak var viewModel: ProductsSortingIndicatorViewModel?
    private let dispooseBag = DisposeBag()

    // MARK: Init and Deinit
    init(viewModel: ProductsSortingIndicatorViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setupViews()
        prepareConstraints()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        accessibilityTraits = .button
        isAccessibilityElement = true

        setupImageView()
        setupArrowView()
        setupTextLabel()
    }

    private func setupImageView() {
        let view = UIImageView()
        view.image = UIImage(named: Constants.ImageView.imageName)
        view.tintColor = .sortingAccentColor

        addSubview(view)
        self.imageView = view
    }

    private func setupArrowView() {
        let view = UIImageView()
        view.image = UIImage(named: Constants.ArrowView.imageName)
        view.tintColor = .sortingAccentColor

        addSubview(view)
        self.arrowView = view
    }

    private func setupTextLabel() {
        let label = UILabel()
        label.font = .sortingHeaderButton
        label.textColor = .sortingAccentColor
        label.numberOfLines = 1

        addSubview(label)
        self.textLabel = label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let imageView, let arrowView else { return }

        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        arrowView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(Constants.ArrowView.leading)
            $0.centerY.equalTo(imageView.snp.centerY)
        }

        textLabel?.snp.makeConstraints {
            $0.leading.equalTo(arrowView.snp.trailing).offset(Constants.Label.leading)
            $0.centerY.equalTo(imageView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        guard let textLabel else { return }

        viewModel?.isArrowUp
            .subscribe(onNext: { [weak self] isArrowUp in
                self?.toggleArrowDirection(isArrowUp)
            })
            .disposed(by: dispooseBag)

        viewModel?.title
            .bind(to: textLabel.rx.text)
            .disposed(by: dispooseBag)

        viewModel?.accessibilityTitle
            .subscribe(onNext: { [weak self] in
                self?.accessibilityLabel = $0
            })
            .disposed(by: dispooseBag)
    }

    // MARK: - Private Methods
    private func toggleArrowDirection(_ isUp: Bool) {
        arrowView?.transform = isUp ? .identity : .init(rotationAngle: .pi)
    }
}

private enum Constants {
    enum ImageView {
        static let imageName = "sort"
    }

    enum ArrowView {
        static let imageName = "sortArrow"
        static let leading: CGFloat = 1
    }

    enum Label {
        static let leading: CGFloat = 5
    }
}
