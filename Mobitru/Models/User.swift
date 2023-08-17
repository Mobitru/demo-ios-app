//
//  User.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 26.01.23.
//

import Foundation

final class User: Codable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var address: String?

    init(with response: LoginResponse) {
        firstName = response.firstName
        lastName = response.lastName
        email = response.email
        address = response.address
    }
}
