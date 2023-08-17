//
//  HomeViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import UIKit
import RxSwift

final class HomeViewController: UITabBarController {
    // MARK: Init and Deinit
    init() {
        super.init(nibName: nil, bundle: nil)

        setupApperance()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupApperance() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }

    private func setupView() {
        tabBar.tintColor = .tabBarItemAccentTint
        tabBar.unselectedItemTintColor = .tabBarItemTint
        tabBar.accessibilityIdentifier = "bottomTabBar"
    }
}
