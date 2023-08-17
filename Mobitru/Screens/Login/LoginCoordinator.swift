//
//  LoginCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 22.03.23.
//

import RxSwift
import UIKit

enum LoginResult {
    case didLogin
}

final class LoginCoordinator: BaseCoordinator<LoginResult> {
    // MARK: Variables
    private let loginManager: LoginManager

    // MARK: Init and Deinit
    init(loginManager: LoginManager) {
        self.loginManager = loginManager

        super.init()
    }

    // MARK: Override
    override func start() -> Observable<LoginResult> {
        let viewModel = LoginViewModel(loginManager: loginManager)
        let controller = LoginViewController(viewModel)
        let navigationContrroller = UINavigationController(rootViewController: controller)
        show(navigationContrroller, style: .initial)

        return .never()
    }
}
