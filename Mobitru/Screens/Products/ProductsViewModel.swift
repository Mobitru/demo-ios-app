//
//  ProductsViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import RxSwift
import RxRelay

final class ProductsViewModel {
    // MARK: Variables
    let products: BehaviorRelay<[Product]>

    let sortingViewModel: ProductsSortingViewModel
    let sortingIndicatorViewModel: ProductsSortingIndicatorViewModel

    let shouldPresentCart = PublishSubject<Void>()
    var cartItems: BehaviorRelay<[CartItem]>
    var cartItemsCount: BehaviorRelay<Int>

    private let productsManager: ProductsManager
    private weak var cartManager: CartManager!
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(productsManager: ProductsManager,
         cartManager: CartManager)
    {
        self.productsManager = productsManager
        self.products = productsManager.products
        self.cartManager = cartManager
        self.cartItems = cartManager.cartItems
        self.cartItemsCount = cartManager.cartItemsCount

        self.sortingViewModel = ProductsSortingViewModel(productsManager: productsManager)
        self.sortingIndicatorViewModel = ProductsSortingIndicatorViewModel(productsManager: productsManager)
    }

    // MARK: - Private Methods
    private func sortProducts(_ type: SortingType) {
        productsManager.sortProducts(type)
    }

    // MARK: - Public Methods
    func addToCart(_ product: Product) {
        cartManager.addToCart(product)
    }

    func removeFromCart(_ product: Product) {
        cartManager.removeFromCart(product)
    }

    func isProductInCart(_ product: Product) -> Bool {
        cartManager.isProductInCart(product)
    }
}
