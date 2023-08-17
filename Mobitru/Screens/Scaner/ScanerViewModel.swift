//
//  ScanerViewModel.swift
//  Mobitru
//
//  Created by Oleksandr Voropayev on 02.02.23.
//

import Foundation
import AVFoundation
import RxSwift

final class ScannerViewModel {
    let metadataTypes: Set<AVMetadataObject.ObjectType> = [.qr]
    let error = PublishSubject<ScannerError>()
    let didScanCode = BehaviorSubject<String?>(value: nil)
    let onControllerDeinit = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
}
