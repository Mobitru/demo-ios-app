//
//  BiometricManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift

protocol BiometricManager {
    func performSignIn(reason: String) -> Observable<Result<String, AuthError>>
}
