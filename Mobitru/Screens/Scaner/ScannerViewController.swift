//
//  ScannerViewController.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import UIKit
import AVFoundation
import RxSwift

enum ScannerError: Error {
    case input
    case output
    case notAvailableType
}

final class ScannerViewController:UIViewController {
    // MARK: Variables
    private weak var previewLayer: AVCaptureVideoPreviewLayer?
    private let captureSession: AVCaptureSession

    private let viewModel: ScannerViewModel
    private let disposeBag = DisposeBag()

    // MARK: Init and Deinit
    init(viewModel: ScannerViewModel) {
        self.viewModel = viewModel
        self.captureSession = AVCaptureSession()

        super.init(nibName: nil, bundle: nil)

        setupPreviewLayer()
        prepareBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.onControllerDeinit.onNext(())
        print("DEINIT === " + String(describing: Self.self))
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try prepareInput()
            try prepareOutput()
            setupPreviewLayer()
            DispatchQueue.global(qos: .userInteractive).async { [weak captureSession] in
                captureSession?.startRunning()
            }
        } catch let error as ScannerError {
            viewModel.error.onNext(error)
        } catch {
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async { [weak captureSession] in
                captureSession?.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    // MARK: Setup Views
    private func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }

    // MARK: Prepare Bindings
    private func prepareBindings() {
        viewModel.error
            .subscribe(onNext: { [weak self] _ in
                self?.presentErrorAlert()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private Methods
    private func prepareInput() throws {
        let session = captureSession
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            throw ScannerError.input
        }
    }

    private func prepareOutput() throws {
        let session = captureSession
        let output = AVCaptureMetadataOutput()
        if session.canAddOutput(output) {
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            session.addOutput(output)
            let availableTypes = Set(output.availableMetadataObjectTypes)
            guard viewModel.metadataTypes.isSubset(of: availableTypes) else {
                throw ScannerError.notAvailableType
            }

            output.metadataObjectTypes = Array(viewModel.metadataTypes)
        } else {
            throw ScannerError.output
        }
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection)
    {
        let code = metadataObjects.first
            .flatMap { $0 as? AVMetadataMachineReadableCodeObject }
            .flatMap(\.stringValue)
        guard let code else { return }

        viewModel.didScanCode.onNext(code)
        dismiss(animated: true)
    }
}

extension ScannerViewController {
    private func presentErrorAlert() {
        let alert = UIAlertController(
            title: "An Error has occurred",
            message: "Can't parse promo code",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}
