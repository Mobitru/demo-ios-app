//
//  AccountViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import RxSwift
import RxRelay

private enum Section: Int {
    case details
    case general

    var title: String? {
        switch self {
        case .details: return nil
        case .general: return "General"
        }
    }
}

final class AccountViewModel {
    // MARK: Variables
    let contactCellModel: ReviewOrderContactCellModel
    let aboutCellViewModel = AccountGeneralCellViewModel()

    let didTapAbout = PublishSubject<Void>()
    let didTapEditAccount = PublishSubject<Void>()
    let didTapLogout = PublishRelay<Void>()

    let shouldPresentAboutScreen = PublishSubject<Void>()
    let shouldPresentEditAccount = PublishSubject<Void>()

    private weak var profileManager: ProfileManager!
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
        self.contactCellModel = .init(profileManager: profileManager, isEditable: true)

        prepareBindings()
    }

    // MARK: - Public Methods
    func titleForSection(_ index: Int) -> String? {
        Section(rawValue: index)?.title
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        didTapAbout
            .bind(to: shouldPresentAboutScreen)
            .disposed(by: disposeBag)

        aboutCellViewModel.didTap
            .bind(to: didTapAbout)
            .disposed(by: disposeBag)

        contactCellModel.didTapEdit
            .bind(to: didTapEditAccount)
            .disposed(by: disposeBag)
    }
}
