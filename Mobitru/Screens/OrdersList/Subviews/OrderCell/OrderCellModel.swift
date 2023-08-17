//
//  OrderCellModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.02.23.
//

import Foundation

final class OrderCellModel {
    // MARK: Variables
    let isInProgress: Bool
    let title: String
    let price: String
    let items: [(title: String, count: Int)]

    // MARK: Init and Deinit
    init(_ order: Order) {
        self.isInProgress = order.isInProgress
        self.title = String(format: Constants.title, order.id)
        self.price = Int(order.paymentDetails.total).usdPriceString
        self.items = order.items.map { ($0.product.name, $0.count) }
    }
}

private enum Constants {
    static let title = "Order #%d"
}
