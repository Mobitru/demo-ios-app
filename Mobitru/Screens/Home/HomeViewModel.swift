//
//  HomeViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import Foundation
import RxSwift

final class HomeViewModel {
    // MARK: Variables
    let cartViewModel: CartViewModel
    private weak var cartManager: CartManager?

    let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(cartManager: CartManager) {
        self.cartManager = cartManager
        self.cartViewModel = CartViewModel(cartManager: cartManager)
    }
}
