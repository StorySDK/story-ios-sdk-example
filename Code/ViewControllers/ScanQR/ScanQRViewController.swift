//
//  ScanQRViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 12.06.2023.
//

import UIKit
import AVFoundation
import SnapKit

protocol ScanQRViewControllerDelegate: AnyObject {
    func apiKeyRecognized(_ value: String)
}

final class ScanQRViewController: UIViewController {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var hideInfoMessage: Bool = false
    
    weak var model: SettingsModel?
    weak var coordinator: AppCoordinatorProtocol?
    weak var actionDelegate: ScanQRViewControllerDelegate?
    
    private var infoStaticLabel: UILabel = UILabel()
    private lazy var customView: ScanQRView = ScanQRView(frame: .zero)
    
    init(model: SettingsModel?) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        //customView.delegate = self
        
        view.addSubview(customView)
        
        setupCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Scan QR"
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        customView.addTapTouch(self, action: #selector(onTap))
        customView.backgroundColor = UIColor.spBackground
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func applyStyles() {
        infoStaticLabel.textAlignment = .center
        infoStaticLabel.numberOfLines = 0
        infoStaticLabel.isHidden = hideInfoMessage
    }
    
    private func applySizes() {
        infoStaticLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(70)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            try videoCaptureDevice.lockForConfiguration()
            if videoCaptureDevice.isAutoFocusRangeRestrictionSupported {
                videoCaptureDevice.autoFocusRangeRestriction = .near
            }
            videoCaptureDevice.unlockForConfiguration()
        } catch {
            print("Could not configure video capture device: \(error)")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .hd1280x720
            captureSession?.addInput(videoInput)
            
            hideInfoMessage = true
        } catch {
            print("Could not create video input: \(error)")
            return
        }
        
        if let theCaptureSession = captureSession {
            previewLayer = AVCaptureVideoPreviewLayer(session: theCaptureSession)
            previewLayer?.frame = self.view.bounds
            previewLayer?.videoGravity = .resizeAspectFill
            self.view.layer.insertSublayer(previewLayer!, at: 0)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
    }
    
    func startScanningQR() {
        customView.backgroundColor = UIColor.clear
        captureSession?.startRunning()
    }
    
    private func apiKeyFoundAndRecognized(_ value: String) {
        captureSession?.stopRunning()
        model?.addToken(value: prepareApiKey(value))
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func prepareApiKey(_ value: String) -> String {
        return value
    }
    
    @objc func onTap() {
        dismiss(animated: true, completion: nil)
    }

}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        for metadataObject in metadataObjects {
            if !metadataObject.isKind(of: AVMetadataMachineReadableCodeObject.self) {
                continue
            }
            
            if let readableObject = previewLayer?.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject {
                if let value = readableObject.stringValue {
                    apiKeyFoundAndRecognized(value)
                    break
                }
            }
        }
    }
}
