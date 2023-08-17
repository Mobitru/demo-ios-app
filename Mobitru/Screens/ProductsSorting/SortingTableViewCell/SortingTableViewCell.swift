//
//  SortingTableViewCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 01.02.23.
//

import UIKit
import SnapKit
import RxSwift

final class SortingTableViewCell: UITableViewCell {
    // MARK: Variables
    private weak var titleLabel: UILabel?
    private weak var checkImageView: UIImageView?

    private var disposeBag = DisposeBag()

    // MARK: Init and Deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: Setup Views
    private func setupViews() {
        backgroundColor = .white

        setupTitleLabel()
        setupImageView()
    }

    private func setupTitleLabel() {
        let label = UILabel()

        contentView.addSubview(label)
        self.titleLabel = label
    }

    private func setupImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageView.imageName)

        contentView.addSubview(imageView)
        self.checkImageView = imageView
    }

    // MARK: Prepare Constraints
    private func  prepareConstraints() {
        guard let titleLabel else { return }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.TitleLabel.leading)
            $0.centerY.equalToSuperview()
        }

        checkImageView?.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(Constants.ImageView.leading)
            $0.centerY.equalToSuperview()
            $0.top.trailing.equalToSuperview().inset(Constants.ImageView.standardInset)
            $0.size.equalTo(Constants.ImageView.size)
        }
    }

    // MARK: - Private Methods
    private func toggleAppearance(_ isSelected: Bool, title: String) {
        guard let titleLabel, let checkImageView else { return }

        titleLabel.textColor = isSelected ? .sortingLabelSelected : .sortingLabel
        titleLabel.font = isSelected ? .sortingLabelSelected : .sortingLabel
        checkImageView.tintColor = isSelected ? .sortingImageSelected : .sortingImage

        let label = isSelected ? Constants.accessibilityLabelSelected : Constants.accessibilityLabelNotSelected
        self.accessibilityLabel = String(format: label, title)
    }

    // MARK: - Public Methods
    func fill(with viewModel: SortingTableViewCellViewModel) {
        let title = viewModel.sortingType.label
        titleLabel?.text = title

        viewModel.isSelected
            .subscribe(onNext: { [weak self] isSelected in
                self?.toggleAppearance(isSelected, title: title)
            })
            .disposed(by: disposeBag)
    }
}

private enum Constants {
    static let accessibilityLabelSelected = "Option name: %@. Selected."
    static let accessibilityLabelNotSelected = "Option name: %@. Not selected."

    enum ImageView {
        static let imageName = "done"
        static let leading: CGFloat = 8
        static let standardInset: CGFloat = 16
        static let size: CGFloat = 24
    }

    enum TitleLabel {
        static let leading: CGFloat = 16
    }
}
