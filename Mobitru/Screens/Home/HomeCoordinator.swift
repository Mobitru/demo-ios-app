//
//  HomeCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import RxSwift
import UIKit

enum HomeCoordinatorResult {
    case didPresent(controller: UIViewController)
    case switchToProducts
    case didLogout
}

final class HomeCoordinator: BaseCoordinator<HomeCoordinatorResult> {
    // MARK: Variables
    private let profileManager: ProfileManager
    private let cartManager: CartManager
    private let ordersManager: OrdersManager

    // MARK: Init and Deinit
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
        self.cartManager = CartManagerImpl()
        self.ordersManager = OrdersManagerImpl()

        super.init()
    }

    // MARK: Override
    override func start() -> Observable<HomeCoordinatorResult> {
        let tabBarController = HomeViewController()
        show(tabBarController, style: .initial)

        let productsResult = coordinateToProducts()
        let ordersResult = coordinateToOrders()
        let accountResult = coordinateToAccount()

        Observable.zip(productsResult.getController(), ordersResult.getController(), accountResult.getController())
            .subscribe(onNext: { [weak tabBarController] in
                tabBarController?.setViewControllers([$0, $1, $2], animated: true)
            })
            .disposed(by: disposeBag)

        return .merge(productsResult, ordersResult, accountResult)
            .do(onNext: { [weak tabBarController] result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if case .switchToProducts = result {
                        tabBarController?.selectedIndex = 0
                    }
                }
            })
            .flatMap { _ in
                Observable<HomeCoordinatorResult>.never()
            }
    }

    // MARK: - Private Methods
    private func coordinateToProducts() -> Observable<HomeCoordinatorResult> {
        coordinate(to: ProductsCoordinator(profileManager: profileManager, cartManager: cartManager, ordersManager: ordersManager))
    }

    private func coordinateToOrders() -> Observable<HomeCoordinatorResult> {
        coordinate(to: OrdersListCoordinator(profileManager: profileManager, cartManager: cartManager, ordersManager: ordersManager))
    }

    private func coordinateToAccount() -> Observable<HomeCoordinatorResult> {
        coordinate(to: AccountCoordinator(profileManager: profileManager))
    }
}

private extension Observable where Element == HomeCoordinatorResult {
    func getController() -> Observable<UIViewController> {
        compactMap {
            if case .didPresent(let controller) = $0 {
                return controller
            }

            return nil
        }
        .take(1)
    }
}
