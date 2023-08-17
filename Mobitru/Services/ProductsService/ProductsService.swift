//
//  ProductsService.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import RxSwift

enum ProductsError: Error {
    case general
}

protocol ProductsService {
    func getProducts() -> Observable<Result<[Product], ProductsError>>
}
