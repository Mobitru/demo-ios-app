//
//  AccountGeneralCellViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import RxSwift

final class AccountGeneralCellViewModel {
    let title = "About the app"
    let didTap = PublishSubject<Void>()
}
