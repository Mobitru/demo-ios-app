//
//  AccountViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import UIKit
import RxSwift

final class AccountViewController: UIViewController {
    // MARK: Variables
    private weak var tableView: UITableView?
    private weak var logoutButton: UIButton?

    private let viewModel: AccountViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(_ viewModel: AccountViewModel) {
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
        title = Constants.title

        setupTabBarItem()
        setupTableView()
        setupLogoutButton()
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.dataSource = self

        view.addSubview(tableView)
        self.tableView = tableView
    }

    private func setupLogoutButton() {
        let button = UIButton()
        button.setTitle(Constants.Button.title, for: .normal)
        button.backgroundColor = .textFieldError
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .button
        button.layer.cornerRadius = Constants.Button.cornerRadius
        button.accessibilityIdentifier = "Logout"

        view.addSubview(button)
        self.logoutButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        tableView?.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(Constants.TableView.leading)
            $0.trailing.equalToSuperview().inset(Constants.TableView.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        logoutButton?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.Button.leading)
            $0.trailing.equalToSuperview().inset(Constants.Button.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Button.bottom)
            $0.height.equalTo(Constants.Button.height)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        logoutButton?.rx.tap
            .bind(to: viewModel.didTapLogout)
            .disposed(by: disposeBag)

        viewModel.shouldPresentAboutScreen
            .subscribe(onNext: { [weak self] _ in
                self?.presentAboutScreen()
            })
            .disposed(by: disposeBag)

        viewModel.didTapEditAccount
            .subscribe(onNext: { [weak self] _ in
                self?.presentEditAccountScreen()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func presentAboutScreen() {
        let viewController = AboutViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentEditAccountScreen() {
        viewModel.shouldPresentEditAccount.onNext(())
    }
}

// MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForSection(section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = ReviewOrderContactCell()
            cell.fill(with: viewModel.contactCellModel)

            return cell
        case 1:
            let cell = AccountGeneralCell()
            let cellViewModel = viewModel.aboutCellViewModel
            cell.fill(with: cellViewModel)

            return cell
        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Constants
extension AccountViewController {
    private func setupTabBarItem() {
        tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "person"),
            selectedImage: UIImage(named: "person_fill")
        )
        tabBarItem.accessibilityLabel = Constants.title
    }
}

private enum Constants {
    static let title = "My account"

    enum TableView {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
    }

    enum Button {
        static let title = "Logout"
        static let cornerRadius: CGFloat = 8
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
        static let bottom: CGFloat = 16
        static let height: CGFloat = 48
    }
}
