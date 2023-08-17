//
//  LoginViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 12.01.23.
//

import Foundation
import RxSwift
import RxRelay

final class LoginViewModel {
    // MARK: Variables
    let loginTextFieldViewModel = TextFieldViewModel(textFieldType: .login)
    let passwordTextFieldViewModel = TextFieldViewModel(textFieldType: .passwword)
    let shouldShowSigninError = PublishRelay<Bool>()

    private let signinResult = PublishRelay<Result<User, AuthError>>()

    private let loginManager: LoginManager
    private var disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(loginManager: LoginManager = LoginManagerImpl()) {
        self.loginManager = loginManager
        prepareBindings()
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        loginManager.signinResult
            .bind(to: signinResult)
            .disposed(by: disposeBag)
        
        signinResult
            .map(\.isFailure)
            .bind(to: shouldShowSigninError)
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods
    func performBiometricSignIn(reason: String) {
        loginManager.performBiometricSignIn(reason: reason)
    }

    func performEmailSignIn() {
        Observable
            .combineLatest(
                loginTextFieldViewModel.text,
                passwordTextFieldViewModel.text
            )
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.loginManager.performEmailSignIn(login: $0, password: $1)
            })
            .disposed(by: disposeBag)
    }
}
