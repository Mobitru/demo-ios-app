//
//  ProductCollectionViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 25.01.23.
//

import Foundation

enum AddToCartButtonState {
    case added
    case notAdded
}

final class ProductCollectionViewModel {
    // MARK: Variables
    let productId: String
    let productTitle: String
    let imageName: String
    let price: Int
    let oldPrice: Int?
    let discount: String?
    var buttonState: AddToCartButtonState

    var hasDiscount: Bool {
        discount != nil
    }

    // MARK: Init and Deinit
    init(product: Product, addToCartButtonState: AddToCartButtonState) {
        productId = product.id
        productTitle = product.name
        imageName = product.image

        let price = product.discountPrice ?? product.price
        self.price = Int(price)
        let oldPrice = product.discountPrice != nil ? product.price : nil
        self.oldPrice = oldPrice.map(Int.init)
        discount = product.discountValue        
        buttonState = addToCartButtonState
    }
}
