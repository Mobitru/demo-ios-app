//
//  TextFieldViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 17.01.23.
//

import RxSwift
import RxRelay

enum TextFieldType {
    case login
    case passwword
    case general(title: String?, errorText: String?, initialValue: String?)
}

final class TextFieldViewModel {
    let textFieldType: TextFieldType
    let text: BehaviorRelay<String>
    let shouldShowError = BehaviorSubject<Bool>(value: false)

    init(textFieldType: TextFieldType) {
        self.textFieldType = textFieldType
        var initialText = ""
        if case .general(_, _, let initialValue) = textFieldType, let initialValue {
            initialText = initialValue
        }

        self.text = .init(value: initialText)
    }
}
