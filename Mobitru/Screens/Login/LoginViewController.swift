//
//  LoginViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 12.01.23.
//

import UIKit
import SnapKit
import RxSwift
import LocalAuthentication

final class LoginViewController: UIViewController {
    // MARK: Variables
    private weak var contentStackView: UIStackView?
    private weak var infoLabel: UILabel?
    private weak var warningView: LoginErrorView?
    private weak var loginFieldView: TextFieldView?
    private weak var passwordFieldView: TextFieldView?
    private weak var signInButton: Button?
    private weak var typeAndSignInButton: Button?
    private weak var biometricAuthButton: Button?

    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        setupViews()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    private func setupViews() {
        view.backgroundColor = .white
        addNavBarLogo()

        setupContentStackView()
        setupInfoLabel()
        setupWarningView()
        setupLoginFieldView()
        setupPasswordFieldView()
        setupSignInButton()
        setupTypeAndSignInButton()
        setupBiometricAuthButton()
        prepareConstraints()
    }

    // MARK: Setup views
    private func setupContentStackView() {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        contentStackView.spacing = Constants.ContentStackView.spacing

        view.addSubview(contentStackView)
        self.contentStackView = contentStackView
    }

    private func setupInfoLabel() {
        let label = UILabel()
        label.text = Constants.infoLabelTitle
        label.font = .label
        label.numberOfLines = 0

        contentStackView?.addArrangedSubview(label)
        contentStackView?.setCustomSpacing(32, after: label)
        self.infoLabel = label
    }

    private func setupWarningView() {
        let warningView = LoginErrorView()
        warningView.isHidden = true

        contentStackView?.addArrangedSubview(warningView)
        self.warningView = warningView
    }

    private func setupLoginFieldView() {
        let loginFieldView = TextFieldView(viewModel.loginTextFieldViewModel)

        contentStackView?.addArrangedSubview(loginFieldView)
        self.loginFieldView = loginFieldView
    }

    private func setupPasswordFieldView() {
        let passwordFieldView = TextFieldView(viewModel.passwordTextFieldViewModel)

        contentStackView?.addArrangedSubview(passwordFieldView)
        contentStackView?.setCustomSpacing(32, after: passwordFieldView)
        self.passwordFieldView = passwordFieldView
    }

    private func setupSignInButton() {
        let signInButton = Button(.signIn)

        contentStackView?.addArrangedSubview(signInButton)
        contentStackView?.setCustomSpacing(16, after: signInButton)
        self.signInButton = signInButton
    }
    
    private func setupTypeAndSignInButton() {
        let typeAndSignInButton = Button(.typeAndSignInButton)

        contentStackView?.addArrangedSubview(typeAndSignInButton)
        contentStackView?.setCustomSpacing(32, after: typeAndSignInButton)
        self.typeAndSignInButton = typeAndSignInButton
    }

    private func setupBiometricAuthButton() {
        let biometricAuthButton = Button(.biometricAuth)

        contentStackView?.addArrangedSubview(biometricAuthButton)
        self.biometricAuthButton = biometricAuthButton
    }

    // MARK: Prepare Constraints
    private func prepareConstraints() {
        contentStackView?.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.ContentStackView.topInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.ContentStackView.horizontalInset)
        }

        signInButton?.snp.makeConstraints {
            $0.height.equalTo(Constants.buttonsHeight)
        }
        
        typeAndSignInButton?.snp.makeConstraints {
            $0.height.equalTo(Constants.buttonsHeight)
        }

        biometricAuthButton?.snp.makeConstraints {
            $0.height.equalTo(Constants.buttonsHeight)
        }
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        signInButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.performEmailSignIn()
            })
            .disposed(by: disposeBag)
        typeAndSignInButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.performCorrectCredentialEnter()
                self?.viewModel.performEmailSignIn()
            })
            .disposed(by: disposeBag)

        biometricAuthButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.performBiometricSignIn(reason: Constants.biometricAuthReason)
            })
            .disposed(by: disposeBag)

        guard let warningView else { return }

        viewModel.shouldShowSigninError
            .map(!)
            .bind(to: warningView.rx.isHidden)
            .disposed(by: disposeBag)

        warningView.closeButton?.rx.tap
            .map { true }
            .bind(to: warningView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func performCorrectCredentialEnter(){
        let loginRequest = LoginRequest.mock
        loginFieldView?.setTextFieldValue(newValue: loginRequest!.login)
        passwordFieldView?.setTextFieldValue(newValue: loginRequest!.password)
    }
}

private enum Constants {
    static let infoLabelTitle = "Use your unique login & password or simply use biometric authentication."
    static let biometricAuthReason = "Authentificate to login!"
    static let buttonsHeight: CGFloat = 48

    enum ContentStackView {
        static let spacing: CGFloat = 12
        static let topInset: CGFloat = 20
        static let horizontalInset: CGFloat = 16
    }
}
