//
//  ReviewOrderProductCellModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation

final class ReviewOrderProductCellModel {
    // MARK: Variables
    let productId: String
    let productTitle: String
    let imageName: String
    let price: Int
    let oldPrice: Int?
    let discount: String?
    var hasDiscount: Bool {
        discount != nil
    }

    var count: Int

    // MARK: Init and Deinit
    init(item: CartItem) {
        let product = item.product
        productId = product.id
        productTitle = product.name
        imageName = product.image

        let price = item.discount.map { 1 - $0 }.map { $0 * product.price } ?? product.discountPrice ?? product.price
        self.price = Int(price)
        let oldPrice = item.discount != nil || product.discountPrice != nil ? product.price : nil
        self.oldPrice = oldPrice.map(Int.init)
        discount = item.discount.map { "-" + String(Int($0 * 100)) + "%" } ?? product.discountValue

        self.count = item.count
    }
}
