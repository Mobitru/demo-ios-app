//
//  ProfileManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation

protocol ProfileManager: AnyObject {
    var user: User? { get }
    var firstName: String? { set get }
    var lastName: String? { set get }
    var email: String? { set get }
    var address: String? { set get }
    var isValidUserForOrder: Bool { get }

    func logout()
}
