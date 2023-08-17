//
//  MockProductsService.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 31.01.23.
//

import Foundation
import RxSwift

final class MockProductsService: ProductsService {
    func getProducts() -> Observable<Result<[Product], ProductsError>> {
        Observable.create {
            $0.on(.next(ProductsResponse.mock))
            
            return Disposables.create()
        }
        .compactMap { $0?.products }
        .map { .success($0) }
    }
}
