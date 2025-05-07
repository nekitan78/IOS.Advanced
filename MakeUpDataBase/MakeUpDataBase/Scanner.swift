//
//  Scanner.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 05.05.2025.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: AnyObject{
    func didFind(barcode:String)
}

final class Scanner:UIViewController{
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerDelegate?
    var isScanning: Bool = true
    
    init(scannerDelegate: ScannerDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        guard let videoCaptureDevice  = AVCaptureDevice.default(for: .video) else{
            return
        }
        
        let videoInput:AVCaptureDeviceInput
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else {
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        }else{
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        if isScanning {
            startScanning()
        }
        
    }
    
    func startScanning() {
        if captureSession.isRunning == false {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }
        isScanning = true
    }
        
    // Public method to stop scanning
    func stopScanning() {
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
        isScanning = false
    }
    func toggleScanning(_ shouldScan: Bool) {
        if shouldScan {
            startScanning()
        } else {
            stopScanning()
        }
    }
}
extension Scanner: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            return
        }
        
        scannerDelegate?.didFind(barcode: barcode)
    }
}
