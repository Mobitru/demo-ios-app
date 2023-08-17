//
//  MockAuthService.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import Foundation
import RxSwift

final class MockAuthService: AuthService {
    // MARK: - Public Methods
    func performSignIn(token: String) -> Observable<Result<User, AuthError>> {
        if performCredentialsCheck(token: token),
           let loginResponse = LoginResponse.mockBiometric {
            let user = User(with: loginResponse)

            return performSignIn(result: .success(user))
        }

        return performSignIn(result: .failure(.failed))
    }

    func performSignIn(login: String, password: String) -> Observable<Result<User, AuthError>> {
        if performCredentialsCheck(login: login, password: password),
           let loginResponse = LoginResponse.mock
        {
            let user = User(with: loginResponse)

            return performSignIn(result: .success(user))
        }

        return performSignIn(result: .failure(.failed))
    }

    // MARK: - Private Methods
    private func performSignIn(result: Result<User, AuthError>) -> Observable<Result<User, AuthError>> {
        Observable.create {
            $0.onNext(result)

            return Disposables.create()
        }
    }

    private func performCredentialsCheck(token: String) -> Bool {
        true
    }

    private func performCredentialsCheck(login: String, password: String) -> Bool {
        let loginRequest = LoginRequest.mock

        return login == loginRequest?.login && password == loginRequest?.password
    }
}
