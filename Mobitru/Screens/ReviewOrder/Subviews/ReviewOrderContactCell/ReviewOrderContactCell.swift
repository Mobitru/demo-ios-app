//
//  ReviewOrderContactCell.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit
import RxSwift

final class ReviewOrderContactCell: UITableViewCell {
    // MARK: Variables
    private weak var containerStackView: UIStackView?
    private weak var editButton: UIButton?
    private weak var vericalStackView: UIStackView?
    private weak var nameLabel: UILabel?
    private weak var emailLabel: UILabel?
    private weak var addressLabel: UILabel?

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

    // MARK: - Public Methods
    func fill(with viewModel: ReviewOrderContactCellModel) {
        nameLabel?.text = viewModel.name
        emailLabel?.text = viewModel.email
        addressLabel?.text = viewModel.address
        editButton?.isHidden = viewModel.isEditButtonHidden

        disposeBag = DisposeBag()
        editButton?.rx.tap
            .bind(to: viewModel.didTapEdit)
            .disposed(by: disposeBag)
    }

    // MARK: Setup Views
    private func setupViews() {
        setupContainerStackView()
        setupVericalStackView()
        setupNameLabel()
        setupEmailLabel()
        setupAddressLabel()
        setupEditButton()
    }

    private func setupContainerStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = Constants.stackViewSpacing

        contentView.addSubview(stackView)
        self.containerStackView = stackView
    }

    private func setupVericalStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constants.stackViewSpacing

        containerStackView?.addArrangedSubview(stackView)
        self.vericalStackView = stackView
    }

    private func setupNameLabel() {
        self.nameLabel = setupLabel(with: .contactCellTitle)
    }

    private func setupEmailLabel() {
        self.emailLabel = setupLabel(with: .sortingHeaderButton)
    }

    private func setupAddressLabel() {
        self.addressLabel = setupLabel(with: .sortingHeaderButton)
    }

    private func setupLabel(with font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .buttonTint
        vericalStackView?.addArrangedSubview(label)

        return label
    }

    private func setupEditButton() {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.buttonImageName), for: .normal)
        button.tintColor = .buttonTint
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        containerStackView?.addArrangedSubview(button)
        self.editButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        containerStackView?.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.stackViewEdges)
        }

        editButton?.snp.makeConstraints {
            $0.height.width.equalTo(Constants.buttonHeight)
        }
    }
}

private enum Constants {
    static let stackViewSpacing: CGFloat = 4
    static let stackViewEdges: CGFloat = 16
    static let buttonHeight: CGFloat = 24
    static let buttonImageName = "edit"
}
