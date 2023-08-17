//
//  ReviewOrderCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.03.23.
//

import Foundation
import RxSwift

final class ReviewOrderCoordinator: BaseCoordinator<CartCoordinatorResult> {
    // MARK: Variables
    private let order: Order
    private let canSubmit: Bool
    private weak var profileManager: ProfileManager!

    // MARK: Init and Deinit
    init(profileManager: ProfileManager, order: Order, canSubmit: Bool) {
        self.profileManager = profileManager
        self.order = order
        self.canSubmit = canSubmit

        super.init()
    }

    deinit {
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Override
    override func start() -> Observable<CartCoordinatorResult> {
        let viewModel = ReviewOrderViewModel(profileManager: profileManager, order: order, canSubmit: canSubmit)
        let controller = ReviewOrderViewController(viewModel)
        show(controller, style: .push)

        return .merge(
            viewModel.didTapSubmitOrder
                .flatMap { [weak self] _ in
                    guard let self, self.canSubmit else { return Observable<CartCoordinatorResult>.never() }
                    
                    return self.showOrderPlaced()
                },
            viewModel.onControllerDeinit
                .map { .didClose }
        )
    }

    // MARK: - Private Methods
    private func showOrderPlaced() -> Observable<CartCoordinatorResult> {
        let viewModel = OrderPlacedViewModel()
        let viewController = OrderPlacedViewController(viewModel)
        show(viewController, style: .push)

        return viewModel.didTapGoBack
            .compactMap { [weak self] in
                guard let self, self.canSubmit else { return nil }

                return .didSubmitOrder(self.order)
            }
    }
}
