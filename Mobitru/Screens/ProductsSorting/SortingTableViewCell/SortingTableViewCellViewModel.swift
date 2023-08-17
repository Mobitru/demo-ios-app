//
//  SortingTableViewCellViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import Foundation
import RxSwift

final class SortingTableViewCellViewModel {
    // MARK: Variables
    let sortingType: SortingType
    var isSelected: BehaviorSubject<Bool>
    let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(sortingType: SortingType, isSelected: Bool) {
        self.sortingType = sortingType
        self.isSelected = .init(value: isSelected)
    }
}
