//
//  EditAccountViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 03.02.23.
//

import Foundation
import RxSwift
import RxRelay

final class EditAccountViewModel {
    enum State {
        case editAccount
        case provideAddress
        
        var title: String {
            switch self {
            case .editAccount: return "Edit account"
            case .provideAddress: return "Provide address"
            }
        }
        
        var actionButtonTitle: String {
            switch self {
            case .editAccount: return "Save"
            case .provideAddress: return "Review order"
            }
        }
    }

    // MARK: Variables
    let state: State
    
    let firstNameViewModel: TextFieldViewModel
    var isFirstNameValid: Observable<Bool> {
        firstNameViewModel.text.map(\.isEmpty).map(!)
    }
    
    let lastNameViewModel: TextFieldViewModel
    var isLastNameValid: Observable<Bool> {
        lastNameViewModel.text.map(\.isEmpty).map(!)
    }
    
    let emailViewModel: TextFieldViewModel
    var isEmailValid: Observable<Bool> {
        emailViewModel.text.map(\.isEmpty).map(!)
    }
    
    let addressViewModel: TextFieldViewModel
    var isAddressValid: Observable<Bool> {
        addressViewModel.text.map(\.isEmpty).map(!)
    }
    
    var areAllFieldsValid: Observable<Bool> {
        .combineLatest([
            isFirstNameValid,
            isLastNameValid,
            isAddressValid
        ])
        .map {
            $0.reduce(true) { $0 && $1 }
        }
    }
    
    let didTapActionButton =  PublishSubject<Void>()
    let shouldPerformAction = PublishRelay<Void>()
    let onControllerDeinit = PublishSubject<Void>()
    let isActionButtonEnabled = BehaviorSubject<Bool>(value: false)

    private weak var profileManager: ProfileManager!
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(profileManager: ProfileManager, state: State) {
        self.profileManager = profileManager
        self.state = state
        
        self.firstNameViewModel = .init(textFieldType: .general(
            title: "First name",
            errorText: Constants.errorMessage,
            initialValue: profileManager.firstName)
        )
        self.lastNameViewModel = .init(textFieldType: .general(
            title: "Last name",
            errorText: Constants.errorMessage,
            initialValue: profileManager.lastName)
        )
        self.emailViewModel = .init(textFieldType: .general(
            title: "Email",
            errorText: Constants.errorMessage,
            initialValue: profileManager.email)
        )
        self.addressViewModel = .init(textFieldType: .general(
            title: "Address",
            errorText: Constants.errorMessage,
            initialValue: profileManager.address)
        )
        
        prepareBindings()
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        isFirstNameValid
            .map(!)
            .bind(to: firstNameViewModel.shouldShowError)
            .disposed(by: disposeBag)
        
        isLastNameValid
            .map(!)
            .bind(to: lastNameViewModel.shouldShowError)
            .disposed(by: disposeBag)
        
        isAddressValid
            .map(!)
            .bind(to: addressViewModel.shouldShowError)
            .disposed(by: disposeBag)
        
        areAllFieldsValid
            .bind(to: isActionButtonEnabled)
            .disposed(by: disposeBag)
        
        didTapActionButton.withLatestFrom(areAllFieldsValid)
            .filter { $0 }
            .map { _ in () }
            .do(onNext: { [weak self] _ in
                self?.saveAccountDetails()
            })
            .bind(to: shouldPerformAction)
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func saveAccountDetails() {
        profileManager.firstName = firstNameViewModel.text.value
        profileManager.lastName = lastNameViewModel.text.value
        profileManager.email = emailViewModel.text.value
        profileManager.address = addressViewModel.text.value
    }
}

private enum Constants {
    static let errorMessage = "Field can’t be empty"
}
