//
//  ProductsSortingIndicatorViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import Foundation
import RxSwift

final class ProductsSortingIndicatorViewModel {
    // MARK: Variables
    let isArrowUp = BehaviorSubject<Bool>(value: true)
    let title = BehaviorSubject<String>(value: "")
    let accessibilityTitle = BehaviorSubject<String>(value: "")

    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(productsManager: ProductsManager) {
        productsManager.selectedSortingType
            .subscribe(onNext: { [weak self] in
                self?.accessibilityTitle.onNext($0.accessibilityLabel)
                self?.title.onNext($0.description)
                self?.isArrowUp.onNext($0.direction.isAscending)
            })
            .disposed(by: disposeBag)
    }
}
