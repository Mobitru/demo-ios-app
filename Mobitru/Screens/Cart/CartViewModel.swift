//
//  CartViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import Foundation
import RxSwift
import RxRelay

final class CartViewModel {
    // MARK: Variables
    let didTapEmptyCartButton = PublishRelay<Void>()
    let didTapConfirmButton = PublishRelay<Void>()
    let didTapApplyPromoButton = PublishRelay<Void>()
    let didTapRemovePromoCode = PublishRelay<Void>()
    let onControllerDeinit = PublishSubject<Void>()

    var cartItems: BehaviorRelay<[CartItem]>
    var cartItemsCount: BehaviorRelay<Int>
    let appliedPromoCode: BehaviorRelay<String?>

    private weak var cartManager: CartManager!
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        self.cartItems = cartManager.cartItems
        self.cartItemsCount = cartManager.cartItemsCount
        self.appliedPromoCode = cartManager.appliedPromoCode

        prepapreBindings()
    }

    // MARK: - Public Methods
    func addToCart(_ product: Product) {
        cartManager.addToCart(product)
    }

    func removeFromCart(_ product: Product) {
        cartManager.removeFromCart(product)
    }

    // MARK: - Private Methods
    private func prepapreBindings() {
        didTapRemovePromoCode
            .subscribe(onNext: { [weak self] _ in
                self?.cartManager.applyPromoCode(nil)
            })
            .disposed(by: disposeBag)
    }
}

