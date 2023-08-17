//
//  CartManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

protocol CartManager: AnyObject {
    var cartItems: BehaviorRelay<[CartItem]> { get }
    var cartItemsCount: BehaviorRelay<Int> { get }
    var appliedPromoCode: BehaviorRelay<String?> { get }

    func addToCart(_ product: Product)
    func removeFromCart(_ product: Product)
    func removeAll()
    func isProductInCart(_ product: Product) -> Bool
    func applyPromoCode(_ code: String?)

    func prepareOrder(for user: User) -> Order
}
