//
//  ReviewOrderViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit

final class ReviewOrderViewController: UIViewController {
    // MARK: Variables
    private weak var tableView: UITableView?
    private weak var confirmButton: UIButton?

    private let viewModel: ReviewOrderViewModel

    // MARK: Init and Deinit
    init(_ viewModel: ReviewOrderViewModel) {
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
        hidesBottomBarWhenPushed = true
        title = viewModel.title

        setupTableView()
        setupConfirmButton()
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.registerCell(with: ReviewOrderProductCell.self)

        view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupConfirmButton() {
        guard viewModel.canSubmitOrder else { return }

        let button = UIButton()
        button.setTitle(Constants.Button.title, for: .normal)
        button.backgroundColor = .accentButton
        button.setTitleColor(.accentButtonTint, for: .normal)
        button.titleLabel?.font = .button
        button.layer.cornerRadius = Constants.Button.cornerRadius
        button.addTarget(nil, action: #selector(onConfirmButton), for: .touchUpInside)

        view.addSubview(button)
        self.confirmButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        tableView?.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(Constants.TableView.leading)
            $0.trailing.equalToSuperview().inset(Constants.TableView.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        confirmButton?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.Button.leading)
            $0.trailing.equalToSuperview().inset(Constants.Button.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Button.bottom)
            $0.height.equalTo(Constants.Button.height)
        }
    }

    // MARK: Actions
    @objc private func onConfirmButton() {
        viewModel.didTapSubmitOrder.onNext(())
    }
}

// MARK: - UITableViewDataSource
extension ReviewOrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForSection(section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.productsViewModels.count
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return tableView.dequeueReusableCell(
            with: ReviewOrderProductCell.self,
            indexPath: indexPath,
            configure: { [weak self] cell in
                guard let viewModel = self?.viewModel.productsViewModels[safe: indexPath.row] else { return }

                cell.fill(with: viewModel)
            }
        )
        case 1:
            let cell = ReviewOrderContactCell()
            cell.fill(with: viewModel.contactCellModel)

            return cell
        case 2:
            let cell = ReviewOrderPaymentDetailsCell()
            cell.fill(with: viewModel.paymentDetailsViewModel)
            
            return cell
        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Constants
private enum Constants {
    enum Button {
        static let title = "Confirm & place order"
        static let cornerRadius: CGFloat = 8
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
        static let bottom: CGFloat = 16
        static let height: CGFloat = 48
    }

    enum TableView {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
    }
}
