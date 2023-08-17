//
//  UICollectionViewCell+Identifier.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}
