//
//  Observable+Extensions.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 27.03.23.
//

import RxSwift

extension ObservableType {
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
        compactMap { $0 }
    }
}

