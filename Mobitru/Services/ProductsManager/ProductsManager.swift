//
//  ProductsManager.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

protocol ProductsManager: AnyObject {
    var products: BehaviorRelay<[Product]> { get }
    var sortingTypes: [SortingType] { get }
    var selectedSortingType: BehaviorRelay<SortingType> { get }

    func sortProducts(_ type: SortingType)
}
