//
//  AuthService.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import RxSwift

enum AuthError: Error {
    case notAuthorised
    case failed
}

protocol AuthService {
    func performSignIn(login: String, password: String) -> Observable<Result<User, AuthError>>
    func performSignIn(token: String) -> Observable<Result<User, AuthError>>
}
