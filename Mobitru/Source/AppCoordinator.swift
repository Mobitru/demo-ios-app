//
//  AppCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 22.03.23.
//

import RxSwift
import Foundation

final class AppCoordinator: BaseCoordinator<Void> {
    // MARK: Variables
    private let loginManager: LoginManager
    private let profileManager: ProfileManager

    // MARK: Init
    init(loginManager: LoginManager = LoginManagerImpl()) {
        self.loginManager = loginManager
        self.profileManager = ProfileManagerImpl(loginManager: loginManager)

        super.init()
    }

    // MARK: Override
    override func start() -> Observable<Void> {
        loginManager.isLoggedIn
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isLoggedIn in
                isLoggedIn ? self?.coordinateToHome() : self?.coordinateToLogin()
            })
            .disposed(by: disposeBag)

        return .never()
    }

    // MARK: - Private methods
    private func coordinateToLogin() {
        let coordinator = LoginCoordinator(loginManager: loginManager)

        coordinate(to: coordinator)
            .take(1)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }

    private func coordinateToHome() {
        let coordinator = HomeCoordinator(profileManager: profileManager)

        coordinate(to: coordinator)
            .take(1)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}
