//
//  AccountGeneralCellViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import RxSwift

final class AccountGeneralCellViewModel {
    let title = NSLocalizedString("About the app", comment: "about app view title")
    let didTap = PublishSubject<Void>()
}
