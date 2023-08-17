//
//  Collection+SafeSubscript.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Optional where Wrapped: Collection {
    subscript (safe index: Wrapped.Index) -> Wrapped.Element? {
        return self?[safe: index]
    }
}
