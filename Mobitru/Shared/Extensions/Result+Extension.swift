//
//  Result+Extension.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 19.01.23.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        if case .success = self {
            return true
        }

        return false
    }

    var isFailure: Bool {
        !isSuccess
    }
}
