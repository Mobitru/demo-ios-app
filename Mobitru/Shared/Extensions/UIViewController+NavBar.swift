//
//  UIViewController+NavBar.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.01.23.
//

import UIKit

extension UIViewController {
    func addNavBarLogo() {
        let logoImage = UIImage(named: "logo")?.resizeTo(size: CGSize(width: 150, height: 32))
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.isAccessibilityElement = false
        let item = UIBarButtonItem(customView: logoImageView)

        navigationItem.leftBarButtonItem = item
    }

    func addCartCounter() -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.cartCounterLabel.cgColor
        button.titleLabel?.font = .button
        button.setTitleColor(.tabBarItemTint, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        return button
    }
}

private extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size)
            .image { [weak self] _ in
                self?.draw(in: CGRect(origin: .zero, size: size))
            }
            .withRenderingMode(self.renderingMode)
    }
}
