//
//  OrdersListCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.03.23.
//

import Foundation
import RxSwift
import UIKit

final class OrdersListCoordinator: BaseCoordinator<HomeCoordinatorResult> {
    // MARK: Variables
    private weak var profileManager: ProfileManager!
    private weak var cartManager: CartManager!
    private weak var ordersManager: OrdersManager!

    // MARK: Init and Deinit
    init(profileManager: ProfileManager,
         cartManager: CartManager,
         ordersManager: OrdersManager)
    {
        self.profileManager = profileManager
        self.cartManager = cartManager
        self.ordersManager = ordersManager

        super.init()
    }

    // MARK: Override
    override func start() -> Observable<HomeCoordinatorResult> {
        let viewModel = OrdersListViewModel(profileManager: profileManager, ordersManager: ordersManager, cartManager: cartManager)
        let controller = OrdersListViewController(viewModel)
        let navigationContrroller = UINavigationController(rootViewController: controller)
        viewController = navigationContrroller
        setParent(navigationContrroller)

        viewModel.didSelectOrder
            .subscribe(onNext: { [weak self] in
                self?.showOrderDetails($0)
            })
            .disposed(by: disposeBag)

        return .merge(
            .just(.didPresent(controller: navigationContrroller)),
            viewModel.shouldOpenCart
                .flatMap { [weak self] _ in
                    guard let self else { return Observable<CartCoordinatorResult>.never() }

                    return self.coordinateCart()
                }
                .compactMap {
                    switch $0 {
                    case .didSubmitOrder: return .switchToProducts
                    case .didClose: return nil
                    }
                }
        )
    }

    // MARK: - Private Methods
    private func coordinateCart() -> Observable<CartCoordinatorResult> {
        let coordinator = CartCoordinator(profileManager: profileManager, cartManager: cartManager)
        parentViewController.map(coordinator.setParent)

        return coordinateOnce(to: coordinator)
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { [weak self] in
                if case .didSubmitOrder(let order) = $0 {
                    self?.ordersManager.append(order: order)
                    self?.cartManager.removeAll()
                    self?.popChildren(animated: true)
                }
            })
    }

    private func showOrderDetails(_ order: Order) {
        let viewModel = ReviewOrderViewModel(profileManager: profileManager, order: order, canSubmit: false)
        let viewController = ReviewOrderViewController(viewModel)
        show(viewController, style: .push)
    }
}
