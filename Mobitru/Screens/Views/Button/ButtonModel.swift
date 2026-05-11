//
//  ButtonModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.01.23.
//

import UIKit

enum ButtonModel {
    case signIn
    case typeAndSignInButton
    case biometricAuth
    case crashApp
    case accent(title: String)
    case general(title: String)

    var title: String {
        switch self {
        case .signIn:
            return NSLocalizedString("Sign in", comment: "sign in button title")
        case .typeAndSignInButton:
            return NSLocalizedString("Sign in with correct user", comment: "sign in with user button title")
        case .biometricAuth:
            return NSLocalizedString("Biometric authentication", comment: "bio auth button title")
        case .crashApp:
            return NSLocalizedString("Crash app", comment: "crash app button title")
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
        case .signIn, .typeAndSignInButton, .accent:
            return .accentButton
        case .crashApp:
            return .errorMessage
        case .biometricAuth, .general:
            return .button
        }
    }

    var tintColor: UIColor {
        switch self {
        case .signIn, .typeAndSignInButton, .accent, .crashApp:
            return .accentButtonTint
        case .biometricAuth, .general:
            return .buttonTint
        }
    }
}
