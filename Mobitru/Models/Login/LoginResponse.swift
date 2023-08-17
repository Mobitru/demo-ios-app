//
//  LoginResponse.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 26.01.23.
//

import Foundation

struct LoginResponse: Mockable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let address: String?
}

extension LoginResponse {
    static let mockBiometric: Self? = mock(with: "LoginResponseBiometric")
}
