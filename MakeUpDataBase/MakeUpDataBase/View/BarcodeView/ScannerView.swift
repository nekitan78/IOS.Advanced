//
//  ScannerView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 05.05.2025.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String
    var isScanning: Bool
    
    init(scannedCode: Binding<String>, isScanning: Bool = true) {
        self._scannedCode = scannedCode
        self.isScanning = isScanning
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    func makeUIViewController(context: Context) -> Scanner {
        let scanner = Scanner(scannerDelegate: context.coordinator)
        scanner.isScanning = isScanning
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: Scanner, context: Context) {
        uiViewController.toggleScanning(isScanning)
    }
    
    final class Coordinator: NSObject, ScannerDelegate {
        private var scannerView: ScannerView
        
        init(scannerView: ScannerView){
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            if scannerView.isScanning {
                scannerView.scannedCode = barcode
            }
        }
        
            
    }
}
