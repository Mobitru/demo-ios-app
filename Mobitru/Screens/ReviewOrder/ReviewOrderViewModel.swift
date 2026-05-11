//
//  ReviewOrderViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation
import RxSwift

final class ReviewOrderViewModel {
    // MARK: Variables
    let productsViewModels: [ReviewOrderProductCellModel]
    let contactCellModel: ReviewOrderContactCellModel
    let paymentDetailsViewModel: ReviewOrderPaymentDetailsCellModel

    let title: String
    let canSubmitOrder: Bool

    let didTapSubmitOrder = PublishSubject<Void>()
    let onControllerDeinit = PublishSubject<Void>()

    private let order: Order
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(profileManager: ProfileManager, order: Order, canSubmit: Bool) {
        self.order = order
        self.canSubmitOrder = canSubmit

        self.productsViewModels = order.items.map(ReviewOrderProductCellModel.init)
        self.contactCellModel = ReviewOrderContactCellModel(profileManager: profileManager)
        self.paymentDetailsViewModel = ReviewOrderPaymentDetailsCellModel(paymentDetails: order.paymentDetails)

        self.title = canSubmit ? Constants.reviewTitle : String(format: Constants.orderTitle, order.id)
    }

    // MARK: - Public Methods
    func titleForSection(_ index: Int) -> String? {
        switch index {
        case 1: return Constants.contactSectionTitle
        case 2: return Constants.paymentSectionTitle
        default: return nil
        }
    }
}

private enum Constants {
    static let reviewTitle = NSLocalizedString("Review order", comment: "review order title")
    static let orderTitle = NSLocalizedString("Order #%@", comment: "order title pattern")
    static let contactSectionTitle = NSLocalizedString("Contact details", comment: "contact details title")
    static let paymentSectionTitle = NSLocalizedString("Payment details", comment: "payment details title")
}
