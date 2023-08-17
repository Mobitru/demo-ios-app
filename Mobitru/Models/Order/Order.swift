//
//  Order.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.02.23.
//

import Foundation

enum OrderState: String, Decodable {
    case done = "DONE"
    case inProgress
}

struct Order {
    let id: String
    let items: [CartItem]
    let user: User
    let paymentDetails: PaymentDetails
    let orderState: OrderState

    init(user: User, items: [CartItem], orderState: OrderState = .inProgress) {
        self.id = String.random()
        self.items = items
        self.user = user
        self.paymentDetails = .init(items)
        self.orderState = orderState
    }
}

extension Order {
    var isInProgress: Bool {
        if case .inProgress = orderState {
            return true
        }

        return false
    }
}

extension Order: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case items = "products"
        case user
        case paymentDetails
        case orderState = "state"
    }
}

extension Order: Mockable {
    static var mockJsonName: String = "OrdersResponse"
}

private extension String {
    static func random(of chars: String = "0123456789", length: Int = 10) -> String {
        String((0..<length).compactMap { _ in chars.randomElement() })
    }
}
