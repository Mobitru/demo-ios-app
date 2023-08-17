//
//  ScannerCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.03.23.
//

import Foundation
import RxSwift

enum ScannerCoordinatorResult {
    case didScanCode(String)
    case didClose
}

final class ScannerCoordinator: BaseCoordinator<ScannerCoordinatorResult> {
    // MARK: Deinit
    deinit {
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Override
    override func start() -> Observable<ScannerCoordinatorResult> {
        let viewModel = ScannerViewModel()
        let viewController = ScannerViewController(viewModel: viewModel)
        show(viewController, style: .present)

        return .merge(
            viewModel.didScanCode
                .unwrap()
                .map { .didScanCode($0) },
            viewModel.onControllerDeinit
                .map { .didClose }
        )
    }
}
