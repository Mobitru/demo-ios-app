//
//  SortingType.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 27.03.23.
//

import Foundation

enum SortingType: Equatable {
    case price(direction: SortingDirection)
    case name(direction: SortingDirection)

    var direction: SortingDirection {
        switch self {
        case .price(let direction), .name(let direction): return direction
        }
    }

    var description: String {
        switch self {
        case .price: return NSLocalizedString("Price", comment: "price description")
        case .name: return NSLocalizedString("Name", comment: "name description")
        }
    }

    var label: String {
        switch self {
        case .price: return accessibilityLabel
        case .name(direction: .ascending): return NSLocalizedString("Product name A-Z", comment: "name sorting asc")
        case .name(direction: .descending): return NSLocalizedString("Product name Z-A", comment: "name sorting asc")
        }
    }

    var accessibilityLabel: String {
        description + " " + direction.description
    }

    static let allCases: [Self] = [
        .price(direction: .ascending),
        .price(direction: .descending),
        .name(direction: .ascending),
        .name(direction: .descending)
    ]
}

enum SortingDirection {
    case ascending
    case descending

    var description: String {
        switch self {
        case .ascending: return NSLocalizedString("ascending", comment: "asc title")
        case .descending: return NSLocalizedString("descending", comment: "desc title")
        }
    }

    var isAscending: Bool {
        if case .ascending = self {
            return true
        }

        return false
    }

    func getPredicate<T: Comparable>() -> (T, T) -> Bool {
        switch self {
        case .ascending: return { $0 > $1 }
        case .descending: return { $0 < $1 }
        }
    }
}
