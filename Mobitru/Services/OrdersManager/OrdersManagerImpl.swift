//
//  OrdersManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.03.23.
//

import Foundation

final class OrdersManagerImpl: OrdersManager {
    private(set) var activeOrders = [Order]()
    let pastOrders: [Order] = Order.mockArray

    init(activeOrders: [Order] = [Order]()) {
        self.activeOrders = activeOrders
    }

    func append(order: Order) {
        activeOrders.append(order)
    }

    func remove(order: Order) {
        activeOrders.removeAll {
            $0.id == order.id
        }
    }
}
