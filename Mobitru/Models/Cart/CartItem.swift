//
//  CartItem.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.02.23.
//

import Foundation

struct CartItem {
    enum Constants {
        static let maxCount = 10
    }

    private(set) var count: Int
    private(set) var discount: Float?
    private let _product: Product
    var product: Product {
        guard let discount else { return _product }

        return _product.applyingDiscount(discount)
    }

    init(product: Product, count: Int = 1) {
        self._product = product
        self.count = count
    }

    @discardableResult
    mutating func increaseCount() -> Int {
        compareCount({ $0 < Constants.maxCount }, andApply: +)
    }

    @discardableResult
    mutating func decreaseCount() -> Int {
        compareCount({ $0 > 0 }, andApply: -)
    }

    private mutating func compareCount(_ comparison: (Int) -> Bool, andApply function: (Int, Int) -> Int) -> Int {
        var count = self.count
        if comparison(count) {
            count = function(count, 1)
        }

        self.count = count

        return count
    }

    mutating func apply(discount: Float?) {
        self.discount = discount
    }
}

extension CartItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case _product = "product"
        case count = "quantity"
    }
}
