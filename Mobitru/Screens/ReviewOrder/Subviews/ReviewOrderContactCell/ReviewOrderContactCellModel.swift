//
//  ReviewOrderContactCellModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation
import RxSwift

final class ReviewOrderContactCellModel {
    // MARK: Variables
    let isEditButtonHidden: Bool
    let didTapEdit = PublishSubject<Void>()

    var name: String? {
        (profileManager.firstName ?? "") + " " + (profileManager.lastName ?? "")
    }

    var email: String {
        profileManager.email ?? ""
    }

    var address: String? {
        profileManager.address
    }

    private weak var profileManager: ProfileManager!

    // MARK: Init and Deinit
    init(profileManager: ProfileManager, isEditable: Bool = false) {
        self.isEditButtonHidden = !isEditable
        self.profileManager = profileManager
    }
}
