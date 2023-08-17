//
//  PaymentDetails.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.02.23.
//

import Foundation

struct PaymentDetails: Decodable {
    let packagingFee: Float
    let subtotal: Float
    let deliveryFee: Float
    let discount: Float
    let total: Float

    init(_ items: [CartItem],
         packagingFee: Float = Constants.packagingFee,
         deliveryFee: Float = Constants.deliveryFee
    ) {
        let (price, discount) = items.reduce((Float.zero, Float.zero)) { partialResult, item in
            let (partialPrice, partialDiscount) = partialResult
            let product = item.product
            let count = item.count

            let appliedDiscount = item.discount.map { $0 * product.price }
            let productDiscount = product.discountPrice.map { product.price - $0 }

            let price = partialPrice + product.price * Float(count)
            let discount = partialDiscount + (appliedDiscount ?? productDiscount ?? Float.zero) * Float(count)

            return (price, discount)
        }

        self.packagingFee = packagingFee
        self.subtotal = price + packagingFee
        self.deliveryFee = deliveryFee
        self.discount = discount
        self.total = subtotal + deliveryFee - discount
    }
}

private enum Constants {
    static let packagingFee: Float = 5
    static let deliveryFee: Float = 10
}
