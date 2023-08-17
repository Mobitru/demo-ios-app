//
//  AppDelegate.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 12.01.23.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    private let coordinator = AppCoordinator()
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator.start()
            .subscribe()
            .disposed(by: disposeBag)

        return true
    }
}
