//
//  ButtonModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.01.23.
//

import UIKit

enum ButtonModel {
    case signIn
    case biometricAuth
    case accent(title: String)
    case general(title: String)

    var title: String {
        switch self {
        case .signIn:
            return "Sign in"
        case .biometricAuth:
            return "Biometric authentication"
        case .accent(let title), .general(let title):
            return title
        }
    }

    var logoName: String? {
        switch self {
        case .biometricAuth:
            return "finger"
        default:
            return nil
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .signIn, .accent:
            return .accentButton
        case .biometricAuth, .general:
            return .button
        }
    }

    var tintColor: UIColor {
        switch self {
        case .signIn, .accent:
            return .accentButtonTint
        case .biometricAuth, .general:
            return .buttonTint
        }
    }
}
