//
//  ProductsSortingViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import UIKit
import SnapKit
import RxSwift

final class ProductsSortingViewController: UIViewController {
    // MARK: Variables
    private weak var tableView: UITableView?
    private weak var actionButton: UIButton?

    private let viewModel: ProductsSortingViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(viewModel: ProductsSortingViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        hidesBottomBarWhenPushed = true
        title = Constants.title

        setupTableView()
        setupActionButton()
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.registerCell(with: SortingTableViewCell.self)

        view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupActionButton() {
        let button = Button(.accent(title: Constants.Button.title))

        view.addSubview(button)
        self.actionButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        tableView?.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        actionButton?.snp.makeConstraints {
            $0.height.equalTo(Constants.Button.height)
            $0.leading.trailing.equalToSuperview().inset(Constants.Button.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Button.bottomInset)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        guard let tableView else { return }
        
        viewModel.sortingViewModels
            .bind(to: tableView.rx.items(
                cellIdentifier: SortingTableViewCell.identifier,
                cellType: SortingTableViewCell.self
            )) { index, viewModel, cell in
                cell.fill(with: viewModel)
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(SortingTableViewCellViewModel.self)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.select(sortingViewModel: $0)
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView?.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)

        actionButton?.rx.tap
            .bind(to: viewModel.didTapApply)
            .disposed(by: disposeBag)

        viewModel.didTapApply
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.selectedViewModelSortingType
            .map(\.accessibilityLabel)
            .subscribe(onNext: { [weak self] in
                self?.actionButton?.accessibilityHint = String(format: Constants.Button.accessibilityHint, $0)
            })
            .disposed(by: disposeBag)
    }
}

private enum Constants {
    static let title = "Sort by"

    enum Button {
        static let title = "Apply"
        static let accessibilityHint = "Activate to apply %@ sorting opttion"
        static let height: CGFloat = 48
        static let horizontalInset: CGFloat = 16
        static let bottomInset: CGFloat = 16
    }
}
