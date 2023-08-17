//
//  ProductsViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 20.01.23.
//

import UIKit
import RxSwift
import RxGesture

final class ProductsViewController: UIViewController {
    // MARK: Variables
    private weak var cartButton: UIButton?
    private weak var headerView: ProductsHeaderView?
    private weak var collectionView: UICollectionView?

    private let viewModel: ProductsViewModel
    private var disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(_ viewModel: ProductsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        accessibilityLabel = "Products"
        
        setupTabBarItem()
        setupHeaderView()
        setupCollectionView()
        addNavBarLogo()
        self.cartButton = addCartCounter()
    }

    private func setupTabBarItem() {
        tabBarItem = UITabBarItem(
            title: Constants.TabBar.title,
            image: UIImage(named: Constants.TabBar.imageName),
            selectedImage: UIImage(named: Constants.TabBar.selectedImageName)
        )
    }

    private func setupHeaderView() {
        let viewModel = viewModel.sortingIndicatorViewModel
        let headerView = ProductsHeaderView(sortingViewModel: viewModel)

        view.addSubview(headerView)
        self.headerView = headerView
    }

    private func setupCollectionView() {
        typealias C = Constants.CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: C.verticalSectionInset,
                                           left: C.horizontalSectionInset,
                                           bottom: C.verticalSectionInset,
                                           right: C.horizontalSectionInset)
        layout.minimumInteritemSpacing = C.interitemSpacing
        layout.minimumLineSpacing = C.lineSpacing
        let itemWidth = (view.frame.width - 2 * C.horizontalSectionInset - C.interitemSpacing) / 2
        let itemHeight = itemWidth + C.itemFooterHeight
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )

        viewModel.products
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: ProductCollectionViewCell.identifier,
                cellType: ProductCollectionViewCell.self
            )) { [weak viewModel] index, model, cell in
                guard let viewModel else { return }

                let buttonState = viewModel.isProductInCart(model) ? AddToCartButtonState.added : .notAdded
                let cellViewModel = ProductCollectionViewModel(product: model, addToCartButtonState: buttonState)
                cell.fill(with: cellViewModel)
                cell.addButton?.rx.tap
                    .subscribe(onNext: { _ in
                        switch buttonState {
                        case .added: viewModel.removeFromCart(model)
                        case .notAdded: viewModel.addToCart(model)
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        viewModel.cartItems
            .map { $0.map(\.product) }
            .distinctUntilChanged(\.count)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView?.reloadData()
            })
            .disposed(by: disposeBag)

        self.collectionView = collectionView
        view.addSubview(collectionView)
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let headerView else { return }

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constants.HeaderView.height)
        }

        collectionView?.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        guard let cartButton, let headerView else { return }
        
        viewModel.cartItemsCount
            .subscribe(onNext: { [weak self] in
                let button = self?.cartButton
                button?.setTitle(String(format: Constants.CartButton.title, $0), for: .normal)
                button?.accessibilityLabel = String(format: Constants.CartButton.accessibilityLabel, $0)
                button?.accessibilityHint = Constants.CartButton.accessibilityHint
                button?.accessibilityIdentifier = "cartButton"
            })
            .disposed(by: disposeBag)

        cartButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presentCartView()
            })
            .disposed(by: disposeBag)

        viewModel.products
            .map(\.count)
            .subscribe(onNext: headerView.fill(with:))
            .disposed(by: disposeBag)

        headerView.sortingView?.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presentSortingView()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func presentCartView() {
        viewModel.shouldPresentCart.onNext(())
    }

    private func popCartViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

    private func presentSortingView() {
        let viewModel = self.viewModel.sortingViewModel
        let viewController = ProductsSortingViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private enum Constants {
    enum TabBar {
        static let title = "Home"
        static let imageName = "home"
        static let selectedImageName = "home_fill"
    }

    enum CartButton {
        static let title = " Cart (%d) "
        static let accessibilityLabel = "Cart: %d items in the cart"
        static let accessibilityHint = "Dubble tap to open the cart"
    }

    enum HeaderView {
        static let height: CGFloat = 40
    }

    enum CollectionView {
        static let horizontalSectionInset: CGFloat = 16
        static let verticalSectionInset: CGFloat = 4
        static let interitemSpacing: CGFloat = 32
        static let lineSpacing: CGFloat = 24
        static let itemFooterHeight: CGFloat = 118
    }
}
