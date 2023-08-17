//
//  LoginManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

final class LoginManagerImpl: LoginManager {
    // MARK: Variables
    let isLoggedIn =  BehaviorSubject<Bool>(value: false)
    let signinResult = PublishRelay<Result<User, AuthError>>()

    private let authService: AuthService
    private let biometricManager: BiometricManager
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(authService: AuthService = MockAuthService(), biometricManager: BiometricManager = BiometricManagerImpl()) {
        self.authService = authService
        self.biometricManager = biometricManager
        prepareBindings()
    }

    // MARK: - Public Methods
    func logout() {
        isLoggedIn.onNext(false)
    }

    func performEmailSignIn(login: String, password: String) {
        authService.performSignIn(login: login, password: password)
            .take(1)
            .bind(to: signinResult)
            .disposed(by: disposeBag)
    }

    func performBiometricSignIn(reason: String) {
        biometricManager.performSignIn(reason: reason)
            .flatMap { [weak self] in
                switch $0 {
                case .success(let token):
                    return self?.authService.performSignIn(token: token) ?? .never()
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
            .take(1)
            .bind(to: signinResult)
            .disposed(by: disposeBag)
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        signinResult
            .map(\.isSuccess)
            .bind(to: isLoggedIn)
            .disposed(by: disposeBag)
    }
}
