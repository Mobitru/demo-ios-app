//
//  Mockable.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 26.01.23.
//

import Foundation

protocol Mockable: Decodable {
    static var mockJsonName: String { get }
}

extension Mockable {
    static var mockJsonName: String {
        String(describing: Self.self)
    }

    static var mock: Self? {
        mock(with: mockJsonName)
    }

    static var mockArray: [Self] {
        mock(with: mockJsonName) ?? []
    }

    static func mock<T: Decodable>(with filename: String) -> T? {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json"),
           let jsonData = try? Data(contentsOf: url) {
            return try! JSONDecoder().decode(T.self, from: jsonData)
        }

        return nil
    }
}
