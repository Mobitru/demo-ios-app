//
//  Optional+Extension.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 14.02.23.
//

import Foundation

extension Optional {
    var isNil: Bool {
        if case .none = self {
            return true
        }

        return false
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        !(self?.isEmpty == false)
    }
}
