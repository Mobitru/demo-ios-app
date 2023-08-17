//
//  Int+Price.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 27.03.23.
//

import Foundation

extension Int {
    var usdPriceString: String {
        "$ \(self)"
    }

    var discountPercentString: String {
        "-\(self)%"
    }
}
