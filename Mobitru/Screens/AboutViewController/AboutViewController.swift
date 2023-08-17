//
//  AboutViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 15.02.23.
//

import UIKit
import RxSwift

final class AboutViewController: UIViewController {
    // MARK: Variables
    private weak var webView: UIWebView?

    private let viewModel: AboutViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(viewModel: AboutViewModel = AboutViewModel()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
        viewModel.loadContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        hidesBottomBarWhenPushed = true
        title = Constants.title
        
        let webView = UIWebView()
        webView.backgroundColor = .white

        view.addSubview(webView)
        self.webView = webView
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        webView?.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        viewModel.webViewContent
            .subscribe(onNext: { [weak self] url in
                self?.open(url: url)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func open(url: URL) {
        webView?.loadRequest(.init(url: url))
    }
}

private enum Constants {
    static let title = "About the app"
}
