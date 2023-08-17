//
//  CartViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import UIKit
import SnapKit
import RxSwift

final class CartViewController: UIViewController {
    // MARK: Variables
    private weak var contentView: UIView?
    private weak var emptyView: EmptyCartView?

    private weak var headerView: UIView?
    private weak var applyPromoButton: UIButton?
    private weak var promoAppiedView: PromoAppliedView?
    private weak var tableView: UITableView?
    private weak var confirmButton: UIButton?

    private let viewModel: CartViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(_ viewModel: CartViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
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
        hidesBottomBarWhenPushed = true
        title = Constants.title

        setupEmptyView()
        setupContentView()
        setupHeaderView()
        setupApplyPromoButton()
        setupPromoAppiedView()
        setupTableView()
        setupConfirmButton()
    }

    private func setupEmptyView() {
        let emptyView = EmptyCartView()

        view.addSubview(emptyView)
        self.emptyView = emptyView
    }

    private func setupContentView() {
        let contentView = UIView()

        view.addSubview(contentView)
        self.contentView = contentView
    }

    private func setupHeaderView() {
        let view = UIView()

        contentView?.addSubview(view)
        headerView = view
    }

    private func setupApplyPromoButton() {
        let button = UIButton()
        button.setTitle(Constants.PromoButton.title, for: .normal)
        button.setTitleColor(.buttonTint, for: .normal)
        button.titleLabel?.font = .button
        button.layer.borderColor = UIColor.bordersColor.cgColor
        button.layer.borderWidth = Constants.PromoButton.borderWidth
        button.layer.cornerRadius = Constants.PromoButton.cornerRadius

        headerView?.addSubview(button)
        self.applyPromoButton = button
    }

    private func setupPromoAppiedView() {
        let view = PromoAppliedView()
        view.isHidden = true

        headerView?.addSubview(view)
        self.promoAppiedView = view
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.registerCell(with: CartTableViewCell.self)

        contentView?.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupConfirmButton() {
        let button = UIButton()
        button.backgroundColor = .accentButton
        button.setTitle(Constants.ConfirmButton.title, for: .normal)
        button.setTitleColor(.accentButtonTint, for: .normal)
        button.titleLabel?.font = .button
        button.layer.cornerRadius = Constants.ConfirmButton.cornerRadius

        contentView?.addSubview(button)
        confirmButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let contentView, let headerView else { return }

        emptyView?.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Constants.EmptyView.width)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.leading.bottom.equalToSuperview()
        }

        headerView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        applyPromoButton?.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.PromoButton.verticalInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.PromoButton.horizontalInset)
        }

        promoAppiedView?.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.PromoView.horizontalInset)
        }

        tableView?.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        confirmButton?.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.ConfirmButton.bottomInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.ConfirmButton.horizontalInset)
            $0.height.equalTo(Constants.ConfirmButton.height)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        viewModel.cartItemsCount
            .subscribe(onNext: { [weak self] count in
                self?.emptyView?.isHidden = count != 0
                self?.contentView?.isHidden = count == 0
            })
            .disposed(by: disposeBag)

        emptyView?.actionButton?.rx.tap
            .bind(to: viewModel.didTapEmptyCartButton)
            .disposed(by: disposeBag)

        applyPromoButton?.rx.tap
            .bind(to: viewModel.didTapApplyPromoButton)
            .disposed(by: disposeBag)

        viewModel.appliedPromoCode
            .subscribe(onNext: { [weak self] code in
                self?.togglePromoViews(code)
            })
            .disposed(by: disposeBag)

        promoAppiedView?.deleteButton?.rx.tap
            .map { Optional<String>.none }
            .bind(to: viewModel.appliedPromoCode )
            .disposed(by: disposeBag)

        confirmButton?.rx.tap
            .bind(to: viewModel.didTapConfirmButton)
            .disposed(by: disposeBag)

        bindTableView()
    }

    private func bindTableView() {
        guard let tableView else { return }

        viewModel.cartItems
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: CartTableViewCell.identifier,
                    cellType: CartTableViewCell.self
                )
            ) { [weak self] index, item, cell in
                let viewModel = CartTableViewCellViewModel(item: item)
                cell.fill(with: viewModel)
                cell.plusButton?.rx.tap
                    .subscribe(onNext: { _ in
                        self?.viewModel.addToCart(item.product)
                    })
                    .disposed(by: cell.disposeBag)

                cell.minusButton?.rx.tap
                    .subscribe(onNext: { _ in
                        self?.viewModel.removeFromCart(item.product)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] in
                tableView?.deselectRow(at: $0, animated: false)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func togglePromoViews(_ code: String?) {
        applyPromoButton?.isHidden = code != nil
        promoAppiedView?.isHidden = code == nil
        promoAppiedView?.fill(with: code)
    }
}

private enum Constants {
    static let title = "My cart"

    enum PromoButton {
        static let title = "Apply promo code"
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        static let verticalInset: CGFloat = 12
        static let horizontalInset: CGFloat = 16
    }

    enum PromoView {
        static let horizontalInset: CGFloat = 16
    }

    enum ConfirmButton {
        static let title = "Continue to checkout"
        static let cornerRadius: CGFloat = 8
        static let bottomInset: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let height: CGFloat = 48
    }

    enum EmptyView {
        static let width: CGFloat = 231
    }
}
