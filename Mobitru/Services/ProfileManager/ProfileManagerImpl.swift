//
//  ProfileManagerImpl.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 23.03.23.
//

import Foundation
import RxSwift

final class ProfileManagerImpl: ProfileManager {
    // MARK: Variables
    var firstName: String? {
        set { user?.firstName = newValue }
        get { user?.firstName }
    }

    var lastName: String? {
        set { user?.lastName = newValue }
        get { user?.lastName }
    }

    var email: String? {
        set { user?.email = newValue }
        get { user?.email }
    }

    var address: String? {
        set { user?.address = newValue }
        get { user?.address }
    }

    var isValidUserForOrder: Bool {
        [firstName, lastName, address]
            .map(\.isNilOrEmpty)
            .map(!)
            .reduce(true) { $0 && $1 }
    }

    private(set) var user: User?
    private weak var loginManager: LoginManager!
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(loginManager: LoginManager) {
        self.loginManager = loginManager
        prepareBindings()
    }

    // MARK: - Public Methods
    func logout() {
        user = nil
        loginManager.logout()
    }

    // MARK: - Private Methods
    private func prepareBindings() {
        loginManager.signinResult
            .compactMap {
                if case .success(let user) = $0 {
                    return user
                }

                return nil
            }
            .subscribe(onNext: { [weak self] in
                self?.user = $0
            })
            .disposed(by: disposeBag)
    }
}
