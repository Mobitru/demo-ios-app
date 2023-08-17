//
//  AccountCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import RxSwift
import UIKit

final class AccountCoordinator: ManualCoordinator<HomeCoordinatorResult> {
    // MARK: Variables
    private weak var profileManager: ProfileManager!

    // MARK: Init
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager

        super.init()
    }

    // MARK: Override
    override func start() -> Observable<HomeCoordinatorResult> {
        let viewModel = AccountViewModel(profileManager: profileManager)
        let controller = AccountViewController(viewModel)
        let navigationContrroller = UINavigationController(rootViewController: controller)
        setParent(navigationContrroller)
        viewController = navigationContrroller

        viewModel.shouldPresentEditAccount
            .flatMap { [weak self] in
                self?.coordinateEditAccount() ?? .never()
            }
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .didSaveValidData:
                    self?.popChildren(animated: true)
                case .didClose:
                    break
                }
            })
            .disposed(by: disposeBag)

        return .merge(
            .just(.didPresent(controller: navigationContrroller)),
            viewModel.didTapLogout
                .do(onNext: { [weak self] in
                    self?.profileManager.logout()
                })
                .map { .didLogout }
        )
    }

    // MARK: - Private Methods
    func coordinateEditAccount() -> Observable<EditAccountCoordinatorResult> {
        let coordinator = EditAccountCoordinator(profileManager: profileManager, state: .editAccount)
        viewController.map(coordinator.setParent)

        return coordinateOnce(to: coordinator)
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let self, let child = coordinator else { return }

                self.free(coordinator: child)
            })
    }
}
