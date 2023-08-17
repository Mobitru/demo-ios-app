//
//  UITableView+Dequeue.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(with class: T.Type) {
        register(`class`.self, forCellReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(
        with class: T.Type,
        indexPath: IndexPath,
        configure: ((T)->())?
    ) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: `class`.identifier, for: indexPath)
        if let result = cell as? T {
            configure?(result)

            return cell
        }

        return UITableViewCell()
    }
}
