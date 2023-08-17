//
//  CartCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 24.03.23.
//

import Foundation
import RxSwift

enum CartCoordinatorResult {
    case didSubmitOrder(Order)
    case didClose
}

final class CartCoordinator: ManualCoordinator<CartCoordinatorResult> {
    // MARK: Variables
    private weak var profileManager: ProfileManager!
    private weak var cartManager: CartManager!

    // MARK: Init and Deinit
    init(profileManager: ProfileManager, cartManager: CartManager) {
        self.profileManager = profileManager
        self.cartManager = cartManager

        super.init()
    }

    deinit {
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Override
    override func start() -> Observable<CartCoordinatorResult> {
        let viewModel = CartViewModel(cartManager: cartManager)
        let viewController = CartViewController(viewModel)
        show(viewController, style: .push)

        viewModel.didTapEmptyCartButton
            .subscribe(onNext: { [weak self] _ in
                self?.popController(animated: true)
            })
            .disposed(by: disposeBag)

        return .merge(
            viewModel.didTapConfirmButton
                .flatMap { [weak self] _ -> Observable<CartCoordinatorResult> in
                    guard let self else { return .never() }

                    if self.profileManager.isValidUserForOrder {
                        return self.coordinateReviewOrder()
                    } else {
                        return self.coordinateProvideAddress()
                            .do(onNext: { [weak self] in
                                if case .didSaveValidData = $0 {
                                    self?.popController(animated: false)
                                }
                            })
                            .flatMap { [weak self] in
                                if case .didSaveValidData = $0 {
                                    return self?.coordinateReviewOrder() ?? .never()
                                }

                                return Observable<CartCoordinatorResult>.never()
                            }
                    }
                },
            viewModel.didTapApplyPromoButton
                .flatMap { [weak self] _ in
                    self?.coordinateScanner() ?? .never()
                }
                .do(onNext: { [weak cartManager] in
                    if case .didScanCode(let code) = $0 {
                        cartManager?.applyPromoCode(code)
                    }
                })
                .flatMap { _ -> Observable<CartCoordinatorResult> in
                    .never()
                },
            viewModel.onControllerDeinit
                .map { .didClose }
        )
    }

    // MARK: - Private Methods
    private func coordinateScanner() -> Observable<ScannerCoordinatorResult> {
        let coordinator = ScannerCoordinator()
        viewController.map(coordinator.setParent)

        return coordinateOnce(to: coordinator)
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let self, let child = coordinator else { return }

                self.free(coordinator: child)
            })
    }

    private func coordinateReviewOrder() -> Observable<CartCoordinatorResult> {
        guard let user = profileManager.user else { return .never() }
        
        let order = cartManager.prepareOrder(for: user)
        let coordinator = ReviewOrderCoordinator(profileManager: profileManager, order: order, canSubmit: true)
        viewController.map(coordinator.setParent)
        
        return coordinateOnce(to: coordinator)
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let self, let child = coordinator else { return }
                
                self.free(coordinator: child)
            })
            .filter {
                if case .didClose = $0 {
                    return false
                }

                return true
            }
            .do(onNext: { [weak cartManager] _ in
                cartManager?.applyPromoCode(nil)
            })
    }

    private func coordinateProvideAddress() -> Observable<EditAccountCoordinatorResult> {
        let coordinator = EditAccountCoordinator(profileManager: profileManager, state: .provideAddress)
        parentViewController.map(coordinator.setParent)

        return coordinate(to: coordinator)
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let self, let child = coordinator else { return }
                
                self.free(coordinator: child)
            })
    }
}
