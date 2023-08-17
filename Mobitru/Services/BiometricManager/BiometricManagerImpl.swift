//
//  BiometricManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import LocalAuthentication

final class BiometricManagerImpl: BiometricManager {
    func performSignIn(reason: String) -> Observable<Result<String, AuthError>> {
        Observable.create { observer in
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { isAuthorised, authenticationError in
                    observer.onNext(isAuthorised ? .success(Constants.token) : .failure(.failed))
                }
            } else {
                observer.onNext(.failure(.failed))
            }

            return Disposables.create()
        }
    }
}

private enum Constants {
    static let token = "token"
}
