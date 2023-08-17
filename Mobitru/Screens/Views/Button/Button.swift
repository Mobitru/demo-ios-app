//
//  Button.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.01.23.
//

import UIKit

final class Button: UIButton {
    init(_ viewModel: ButtonModel) {
        super.init(frame: .zero)

        setupView()
        fill(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func fill(with viewModel: ButtonModel) {
        backgroundColor = viewModel.backgroundColor
        setTitle(viewModel.title, for: .normal)
        setTitleColor(viewModel.tintColor, for: .normal)
        if let logo = viewModel.logoName.map(UIImage.init(named:)) {
            setImage(logo, for: .normal)
            tintColor = viewModel.tintColor
        }
    }

    private func setupView() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.bordersColor.cgColor
        titleLabel?.font = .button
    }
}
