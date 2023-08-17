//
//  EditAccountCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 30.03.23.
//

import Foundation
import RxSwift

enum EditAccountCoordinatorResult {
    case didSaveValidData
    case didClose
}

final class EditAccountCoordinator: BaseCoordinator<EditAccountCoordinatorResult> {
    private weak var profileManager: ProfileManager!
    private let state: EditAccountViewModel.State

    init(profileManager: ProfileManager, state: EditAccountViewModel.State) {
        self.profileManager = profileManager
        self.state = state

        super.init()
    }

    deinit {
        print("DEINIT === " + String(describing: Self.self))
    }

    override func start() -> Observable<EditAccountCoordinatorResult> {
        let viewModel = EditAccountViewModel(profileManager: profileManager, state: state)
        let viewController = EditAccountViewController(viewModel)
        show(viewController, style: .push)

        return .merge(
            viewModel.shouldPerformAction.map { .didSaveValidData },
            viewModel.onControllerDeinit.map { .didClose }
        )
    }
}
