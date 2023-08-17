//
//  BaseCoordinator.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 22.03.23.
//

import RxSwift
import UIKit
import Foundation

enum PresentationStyle {
    case initial
    case push
    case present
    case modal
    case modalWithTabBar
    case modalInContext
}

class BaseCoordinator<ResultType> {
    typealias CoordinationResult = ResultType

    // MARK: Variables
    let disposeBag = DisposeBag()
    private let identifier = UUID()
    fileprivate var childCoordinators = [UUID: Any]()

    private var window: UIWindow? { return (UIApplication.shared.delegate as? AppDelegate)?.window }
    private(set) weak var parentViewController: UIViewController?
    weak var viewController: UIViewController?

    // MARK: Init
    init() {}

    init(_ parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }

    // MARK: - Public Methods
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)

        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }

    func coordinateOnce<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        coordinate(to: coordinator).take(1)
    }

    func setParent(_ parent: UIViewController) {
        self.parentViewController = parent
    }

    func show(_ controller: UIViewController, style: PresentationStyle) {
        switch style {
        case .initial:
            viewController = controller
            window?.rootViewController = controller
            window?.makeKeyAndVisible()
        case .push:
            viewController = controller
            let parent = parentViewController
            if let navigationController = parent as? UINavigationController ?? parent?.navigationController {
                navigationController.pushViewController(controller, animated: true)
            }
        case .present:
            viewController = controller
            parentViewController?.present(controller, animated: true, completion: nil)
        case .modal:
            viewController = controller
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
            controller.hidesBottomBarWhenPushed = true
            parentViewController?.present(controller, animated: true, completion: nil)
        case .modalWithTabBar:
            viewController = controller
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            parentViewController?.hidesBottomBarWhenPushed = false
            parentViewController?.definesPresentationContext = true

            if let navigation = parentViewController?.navigationController {
                navigation.pushViewController(controller, animated: true)
            } else {
                parentViewController?.present(controller, animated: true, completion: nil)
            }
        case .modalInContext:
            viewController = controller
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.hidesBottomBarWhenPushed = true
            parentViewController?.present(controller, animated: true, completion: nil)
        }
    }

    func popController(animated: Bool = true) {
        viewController?.navigationController?.popViewController(animated: animated)
        viewController?.dismiss(animated: animated, completion: nil)
    }

    func popChildren(animated: Bool = false) {
        if let navigation = viewController?.navigationController ?? viewController as? UINavigationController {
            navigation.popToRootViewController(animated: animated)
        }

        dismissPresentedControllers(of: viewController)
    }

    // MARK: - Private Methods
    private func dismissPresentedControllers(of viewController: UIViewController?) {
        if let controllerToDismiss = viewController?.presentedViewController {
            controllerToDismiss.dismiss(animated: false) { [weak self, weak viewController] in
                self?.dismissPresentedControllers(of: viewController)
            }
        }
    }

    fileprivate func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    fileprivate func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: - Methods to override
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

class ManualCoordinator<T>: BaseCoordinator<T> {
    final override func free<T>(coordinator: BaseCoordinator<T>) {
        super.free(coordinator: coordinator)
    }

    final func freeAll() {
        childCoordinators = [:]
    }

    final override func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)

        return coordinator.start()
    }
}
