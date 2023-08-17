//
//  CartCounterViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.01.23.
//

import RxRelay

final class CartCounterViewModel {
    let counter = BehaviorRelay<Int>(value: 0)
}
