//
//  EditAccountViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 03.02.23.
//

import UIKit
import RxSwift

final class EditAccountViewController: UIViewController {
    // MARK: Variables
    private weak var stackView: UIStackView?
    private weak var titleLabel: UILabel?
    private weak var firstNameTextField: TextFieldView?
    private weak var lastNameTextField: TextFieldView?
    private weak var emailNameTextField: TextFieldView?
    private weak var addressNameTextField: TextFieldView?
    private weak var actionButton: UIButton?

    private let viewModel: EditAccountViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init
    init(_ viewModel: EditAccountViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareConstraints()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.onControllerDeinit.onNext(())
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        hidesBottomBarWhenPushed = true
        title = viewModel.state.title

        setupStackView()
        setupTitleLabel()
        setupTextFields()
        setupActionButton()
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.StackView.spacing

        view.addSubview(stackView)
        self.stackView = stackView
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.text = Constants.TitleLabel.title
        label.font = .label
        label.textColor = .discountLabelText

        let stackView = self.stackView
        stackView?.addArrangedSubview(label)
        stackView?.setCustomSpacing(Constants.TitleLabel.spacing, after: label)
        self.titleLabel = label
    }

    private func setupTextFields() {
        self.firstNameTextField = prepareTextField(with: viewModel.firstNameViewModel)
        self.lastNameTextField = prepareTextField(with: viewModel.lastNameViewModel)
        self.addressNameTextField = prepareTextField(with: viewModel.addressViewModel)
        let emailNameTextField = prepareTextField(with: viewModel.emailViewModel)
        emailNameTextField.isUserInteractionEnabled = false
        self.emailNameTextField = emailNameTextField
    }

    private func prepareTextField(with viewModel: TextFieldViewModel) -> TextFieldView {
        let result = TextFieldView(viewModel)
        stackView?.addArrangedSubview(result)

        return result
    }

    private func setupActionButton() {
        let button = Button(.accent(title: viewModel.state.actionButtonTitle))

        view.addSubview(button)
        self.actionButton = button
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        guard let stackView else { return }

        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Constants.StackView.horizontalInset)
        }

        actionButton?.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom)
            $0.height.equalTo(Constants.Button.height)
            $0.leading.trailing.equalToSuperview().inset(Constants.Button.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.Button.bottom)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        guard let actionButton else { return }

        actionButton.rx.tap
            .bind(to: viewModel.didTapActionButton)
            .disposed(by: disposeBag)

        viewModel.isActionButtonEnabled
            .bind(to: actionButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

private enum Constants {
    enum TitleLabel {
        static let title = "Please provide your address details to proceed."
        static let spacing: CGFloat = 16
    }

    enum StackView {
        static let horizontalInset: CGFloat = 16
        static let spacing: CGFloat = 12
    }

    enum Button {
        static let height: CGFloat = 48
        static let horizontalInset: CGFloat = 16
        static let bottom: CGFloat = 16
    }
}
