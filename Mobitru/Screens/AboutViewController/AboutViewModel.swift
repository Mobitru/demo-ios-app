//
//  AboutViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import Foundation
import RxSwift
import Network

final class AboutViewModel {
    let webViewContent = PublishSubject<URL>()

    func loadContent() {
        guard let url = URL(string: Constants.defaultUrl) else { return }
        
        webViewContent.onNext(url)
    }
}

private enum Constants {
    static let defaultUrl = "https://mobitru.com/"
}
