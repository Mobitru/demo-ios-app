//
//  OrderPlacedViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import RxSwift

final class OrderPlacedViewModel {
    let didTapGoBack = PublishSubject<Void>()
    let onControllerDeinit = PublishSubject<Void>()
    let disposeBag = DisposeBag()
}
