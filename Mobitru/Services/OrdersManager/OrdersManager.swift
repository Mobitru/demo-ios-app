//
//  OrdersManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.03.23.
//

import Foundation

protocol OrdersManager: AnyObject {
    var activeOrders: [Order] { get }
    var pastOrders: [Order] { get }

    func append(order: Order)
    func remove(order: Order)
}
