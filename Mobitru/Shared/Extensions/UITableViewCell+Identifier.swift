//
//  UITableViewCell+Identifier.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}
