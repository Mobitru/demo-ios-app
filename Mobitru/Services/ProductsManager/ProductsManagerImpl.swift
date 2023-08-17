//
//  ProductsManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift
import RxRelay

final class ProductsManagerImpl: ProductsManager {
    // MARK: Variables
    let products = BehaviorRelay<[Product]>(value: [])
    let sortingTypes: [SortingType]
    let selectedSortingType: BehaviorRelay<SortingType>

    private let productsService: ProductsService
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(productsService: ProductsService = MockProductsService(),
         sortingTypes: [SortingType] = SortingType.allCases,
         selected: SortingType = .price(direction: .ascending))
    {
        self.productsService = productsService
        self.sortingTypes = sortingTypes
        self.selectedSortingType = .init(value: selected)

        prepareBindings()
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        productsService.getProducts()
            .take(1)
            .compactMap {
                if case .success(let products) = $0 {
                    return products
                }

                return nil
            }
            .bind(to: products)
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods
    func sortProducts(_ type: SortingType) {
        selectedSortingType.accept(type)
        products.accept(
            products.value.sorted {
                switch type {
                case .price:
                    return type.direction.getPredicate()($1.price, $0.price)
                case .name:
                    return type.direction.getPredicate()($1.name, $0.name)
                }
            }
        )
    }
}
