//
//  ProductsCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import RxSwift
import UIKit

final class ProductsCoordinator: BaseCoordinator<HomeCoordinatorResult> {
    // MARK: Variables
    private let productsManager: ProductsManager
    private weak var profileManager: ProfileManager!
    private weak var cartManager: CartManager!
    private weak var ordersManager: OrdersManager!

    // MARK: Init and Deinit
    init(productsManager: ProductsManager = ProductsManagerImpl(),
         profileManager: ProfileManager,
         cartManager: CartManager,
         ordersManager: OrdersManager)
    {
        self.productsManager = productsManager
        self.profileManager = profileManager
        self.cartManager = cartManager
        self.ordersManager = ordersManager

        super.init()
    }

    deinit {
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Override
    override func start() -> Observable<HomeCoordinatorResult> {
        let viewModel = ProductsViewModel(productsManager: productsManager, cartManager: cartManager)
        let controller = ProductsViewController(viewModel)
        let navigationContrroller = UINavigationController(rootViewController: controller)
        viewController = navigationContrroller

        return .merge(
            .just(.didPresent(controller: navigationContrroller)),
            viewModel.shouldPresentCart
                .flatMap { [weak self] _ -> Observable<CartCoordinatorResult> in
                    self?.coordinateToCart() ?? .never()
                }
                .do(onNext: { [weak self] in
                    if case .didSubmitOrder(let order) = $0 {
                        self?.ordersManager.append(order: order)
                        self?.popChildren(animated: true)
                        self?.cartManager.removeAll()
                    }
                })
                .flatMap { _ in Observable<HomeCoordinatorResult>.never() }
        )
    }

    // MARK: - Private Methods
    private func coordinateToCart() -> Observable<CartCoordinatorResult> {
        let coordinator = CartCoordinator(profileManager: profileManager, cartManager: cartManager)
        viewController.map(coordinator.setParent)

        return coordinateOnce(to: coordinator)
    }
}
