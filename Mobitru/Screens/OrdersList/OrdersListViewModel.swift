//
//  OrdersListViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.02.23.
//

import Foundation
import RxSwift
import RxRelay

final class OrdersListViewModel {
    // MARK: Variables
    private weak var profileManager: ProfileManager!
    private weak var ordersManager: OrdersManager!
    private var allOrders: [[Order]] {
        [ordersManager.activeOrders, ordersManager.pastOrders]
    }

    let cartItemsCount: BehaviorRelay<Int>

    let didSelectOrder = PublishSubject<Order>()
    let shouldOpenCart = PublishRelay<Void>()

    // MARK: Init and Deinit
    init(profileManager: ProfileManager, ordersManager: OrdersManager, cartManager: CartManager) {
        self.profileManager = profileManager
        self.ordersManager = ordersManager
        self.cartItemsCount = cartManager.cartItemsCount
    }

    // MARK: - Public Methods
    func numberOfSections() -> Int {
        allOrders.count
    }

    func numberOfItems(in section: Int) -> Int {
        allOrders[safe: section]?.count ?? 0
    }

    func title(for section: Int) -> String {
        switch section {
        case 0: return String(format: Constants.inProgressTitle, numberOfItems(in: section))
        case 1: return String(format: Constants.completedTitle, numberOfItems(in: section))
        default: return ""
        }
    }

    func orderCellModel(for indexPath: IndexPath) -> OrderCellModel? {
        allOrders[safe: indexPath.section][safe: indexPath.row].map(OrderCellModel.init)
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let order = allOrders[safe: indexPath.section][safe: indexPath.row] else { return }

        didSelectOrder.onNext(order)
    }
}

private enum Constants {
    static let inProgressTitle = "In progress (%d)"
    static let completedTitle = "Completed (%d)"
}
