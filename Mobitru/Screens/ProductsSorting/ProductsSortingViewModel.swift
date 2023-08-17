//
//  ProductsSortingViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import Foundation
import RxSwift
import RxRelay

final class ProductsSortingViewModel {
    // MARK: Variables
    private var sortingTypes: [SortingType] {
        productsManager.sortingTypes
    }

    private var selectedSortingType: BehaviorRelay<SortingType> {
        productsManager.selectedSortingType
    }

    let selectedViewModelSortingType: BehaviorRelay<SortingType>
    var sortingViewModels: BehaviorRelay<[SortingTableViewCellViewModel]> {
        let selected = selectedSortingType.value
        if selected != selectedViewModelSortingType.value {
            selectedViewModelSortingType.accept(selected)
        }

        return BehaviorRelay(value: sortingTypes.map { [weak self] in
            let viewModel = SortingTableViewCellViewModel(sortingType: $0, isSelected: selected == $0)
            self?.bind(cellViewModel: viewModel)

            return viewModel
        })
    }

    let didTapApply = PublishSubject<Void>()

    private weak var productsManager: ProductsManager!
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(productsManager: ProductsManager)
    {
        self.productsManager = productsManager
        self.selectedViewModelSortingType = .init(value: productsManager.selectedSortingType.value)

        prepareBindings()
    }

    // MARK: Prepare Bindings
    private func bind(cellViewModel: SortingTableViewCellViewModel) {
        selectedViewModelSortingType
            .map { [weak cellViewModel] in
                cellViewModel?.sortingType == $0
            }
            .bind(to: cellViewModel.isSelected)
            .disposed(by: cellViewModel.disposeBag)
    }

    private func prepareBindings() {
        didTapApply.withLatestFrom(selectedViewModelSortingType)
            .subscribe(onNext: { [weak self] in
                self?.productsManager.sortProducts($0)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public Methods
    func select(sortingViewModel: SortingTableViewCellViewModel) {
        selectedViewModelSortingType.accept(sortingViewModel.sortingType)
    }
}
