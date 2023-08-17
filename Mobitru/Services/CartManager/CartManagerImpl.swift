//
//  CartManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

final class CartManagerImpl: CartManager {
    // MARK: Variables
    let cartItems = BehaviorRelay<[CartItem]>(value: [])
    let cartItemsCount = BehaviorRelay<Int>(value: 0)
    let appliedPromoCode = BehaviorRelay<String?>(value: nil)

    private let cart = Cart()
    private let disposeBag = DisposeBag()

    // MARK: Init
    init() {
        prepapreBindings()
    }

    // MARK: - Public Methods
    func addToCart(_ product: Product) {
        cart.append(product)
    }

    func removeFromCart(_ product: Product) {
        cart.remove(product)
    }

    func removeAll() {
        cart.removeAll()
    }

    func isProductInCart(_ product: Product) -> Bool {
        cart.contains(product)
    }

    func applyPromoCode(_ code: String?) {
        appliedPromoCode.accept(code)
    }

    func prepareOrder(for user: User) -> Order {
        Order(user: user, items: cartItems.value)
    }

    // MARK: Prepare Bindings
    private func prepapreBindings() {
        Observable
            .combineLatest(cart.items, appliedPromoCode) { cartItems, promoCode in
                cartItems.map { item in
                    var result = item
                    result.apply(discount: promoCode.map { _ in Constants.promoDiscount })

                    return result
                }
            }
            .bind(to: cartItems)
            .disposed(by: disposeBag)


        cart.items.map(\.count)
            .bind(to: cartItemsCount)
            .disposed(by: disposeBag)
    }
}

private enum Constants {
    static let promoDiscount: Float = 0.25
}
