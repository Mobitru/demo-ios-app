//
//  ReviewOrderPaymentDetailsCellModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation

final class ReviewOrderPaymentDetailsCellModel {
    // MARK: Variables
    let packagingFee: Float
    let subtotal: Float
    let deliveryFee: Float
    let discount: Float
    let total: Float

    // MARK: Init and Deinit
    init(paymentDetails details: PaymentDetails) {
        self.packagingFee = details.packagingFee
        self.subtotal = details.subtotal
        self.deliveryFee = details.deliveryFee
        self.discount = details.discount
        self.total = details.total
    }
}
