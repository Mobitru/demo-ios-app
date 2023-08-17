//
//  OrdersListViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.02.23.
//

import UIKit
import RxSwift
import SnapKit

final class OrdersListViewController: UIViewController {
    // MARK: Variables
    private weak var tableView: UITableView?
    private weak var cartButton: UIButton?

    private let viewModel: OrdersListViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(_ viewModel: OrdersListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView?.reloadData()
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white

        setupTabBarItem()
        addNavBarLogo()
        cartButton = addCartCounter()
        setupTableView()
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(with: OrderCell.self)

        view.addSubview(tableView)
        self.tableView = tableView
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        tableView?.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        guard let cartButton else { return }
        
        viewModel.cartItemsCount
            .map { String(format: Constants.title, $0) }
            .bind(to: cartButton.rx.title())
            .disposed(by: self.disposeBag)

        cartButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentCartView()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func presentCartView() {
        viewModel.shouldOpenCart.accept(())
    }
}

// MARK: -  UITableViewDataSource
extension OrdersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.title(for: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(
            with: OrderCell.self,
            indexPath: indexPath,
            configure: { [weak self] cell in
                guard let viewModel = self?.viewModel.orderCellModel(for: indexPath) else { return }

                cell.fill(with: viewModel)
            }
        )
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension OrdersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

// MARK: - Constants
extension OrdersListViewController {
    private func setupTabBarItem() {
        tabBarItem = UITabBarItem(
            title: "Orders",
            image: UIImage(named: "receipt"),
            selectedImage: UIImage(named: "receipt_fill")
        )
    }
}

private enum Constants {
    static let title = " Cart (%d) "
}
