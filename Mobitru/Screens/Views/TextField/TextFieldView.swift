//
//  TextField.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 13.01.23.
//

import UIKit
import SnapKit
import RxSwift

final class TextFieldView: UIView {
    // MARK: Variables
    private weak var stackView: UIStackView?
    private weak var titleLabel: UILabel?
    private weak var textField: UITextField?
    private weak var errorLabel: UILabel?

    private var disposeBag = DisposeBag()

    // MARK: Init
    init(_ viewModel: TextFieldViewModel) {
        super.init(frame: .zero)

        setupViews()
        prepareConstraints()
        fill(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup Views
    private func setupViews() {
        setupStackView()
        setupTitleLabel()
        setupTextField()
        setupErrorLabel()
    }

    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4

        addSubview(stackView)
        self.stackView = stackView
    }

    private func setupTitleLabel() {
        let label = UILabel()
        label.font = .textFieldTitle
        label.textColor = .textFieldTitle

        stackView?.addArrangedSubview(label)
        self.titleLabel = label
    }

    private func setupTextField() {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.bordersColor.cgColor

        stackView?.addArrangedSubview(textField)
        stackView?.setCustomSpacing(2, after: textField)
        self.textField = textField
    }

    private func setupErrorLabel() {
        let label = UILabel()
        label.font = .textFieldError
        label.textColor = .textFieldError
        label.isHidden = true

        stackView?.addArrangedSubview(label)
        self.errorLabel = label
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        stackView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        textField?.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    // MARK: - Public Methods
    public func fill(with viewModel: TextFieldViewModel) {
        guard let textField else { return }

        disposeBag = DisposeBag()

        switch viewModel.textFieldType {
        case .login:
            titleLabel?.text = "Login"
            textField.accessibilityIdentifier = "Login"
        case .passwword:
            titleLabel?.text = "Password"
            textField.accessibilityIdentifier = "Password"
            textField.isSecureTextEntry = true
        case .general(let title, let errorText, let initialText):
            titleLabel?.text = title
            errorLabel?.text = errorText
            errorLabel?.accessibilityIdentifier = "Error " + title!
            textField.accessibilityIdentifier = title
            textField.text = initialText
        }

        textField.rx.text
            .orEmpty
            .bind(to: viewModel.text)
            .disposed(by: disposeBag)

        viewModel.shouldShowError
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.errorLabel?.isHidden = !$0
            })
            .disposed(by: disposeBag)
    }
    
    public func setTextFieldValue(newValue: String){
        self.textField?.text=""
        self.textField?.insertText(newValue)
    }

}
