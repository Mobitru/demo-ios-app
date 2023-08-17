//
//  Cart.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.02.23.
//

import Foundation
import RxSwift

final class Cart {
    private var _items = [CartItem]()
    let items = BehaviorSubject<[CartItem]>(value: [])

    func append(_ product: Product) {
        if let index = _items.firstIndex(where: { $0.product == product }) {
            _items[index].increaseCount()
        } else {
            _items.append(CartItem(product: product))
        }

        items.on(.next(_items))
    }

    func remove(_ product: Product) {
        guard let index = _items.firstIndex(where: { $0.product == product }) else { return }

        if _items[index].decreaseCount() == 0 {
            _items.removeAll { $0.product == product }
        }

        items.on(.next(_items))
    }

    func removeAll() {
        _items.removeAll()
        items.onNext(_items)
    }

    func contains(_ product: Product) -> Bool {
        _items.first { $0.product == product } != nil
    }
}
