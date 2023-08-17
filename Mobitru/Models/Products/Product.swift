//
//  Product.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import Foundation

struct Product: Decodable {
    let id: String
    let name: String
    let price: Float
    let discountPrice: Float?
    let discountValue: String?
    let image: String
}

extension Product {
    func applyingDiscount(_ discount: Float) -> Product {
        Product(
            id: id,
            name: name,
            price: price,
            discountPrice: price * (1 - discount),
            discountValue: "-" + String(Int(discount * 100)) + "%",
            image: image
        )
    }
}

extension Product: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
