//
//  CartTableViewCellViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import Foundation
import RxSwift

enum MinusButtonState {
    case minus
    case delete
}

final class CartTableViewCellViewModel {
    // MARK: Variables
    let productId: String
    let productTitle: String
    let imageName: String
    let price: Int
    let oldPrice: Int?
    let discount: String?
    let buttonState: AddToCartButtonState
    var hasDiscount: Bool {
        discount != nil
    }

    var count: Int
    var minusButtonState: MinusButtonState {
        count == 1 ? .delete : .minus
    }

    var canAddItems: Bool {
        count < CartItem.Constants.maxCount
    }

    // MARK: Init and Deinit
    init(item: CartItem) {
        let product = item.product
        productId = product.id
        productTitle = product.name
        imageName = product.image

        let price = product.discountPrice ?? product.price
        self.price = Int(price)
        let oldPrice = product.discountPrice != nil ? product.price : nil
        self.oldPrice = oldPrice.map(Int.init)
        discount = product.discountValue

        buttonState = .notAdded
        self.count = item.count
    }
}
