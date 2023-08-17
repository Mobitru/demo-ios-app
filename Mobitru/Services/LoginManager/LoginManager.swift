//
//  LoginManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

protocol LoginManager: AnyObject {
    var isLoggedIn: BehaviorSubject<Bool> { get }
    var signinResult: PublishRelay<Result<User, AuthError>> { get }

    func performEmailSignIn(login: String, password: String)
    func performBiometricSignIn(reason: String) 
    func logout()
}
