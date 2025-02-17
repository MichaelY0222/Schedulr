//
//  ScannerView.swift
//  Schedulr
//
//  Created by Michael Yu on 2025/2/9.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let completion: (String?) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scannerVC = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scannerVC.delegate = context.coordinator
        return scannerVC
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
        }

        func dataScanner(_ scanner: DataScannerViewController, didAdd items: [RecognizedItem]) {
            for item in items {
                if case let .barcode(barcode) = item {
                    DispatchQueue.main.async {
                        self.parent.completion(barcode.payloadStringValue)
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
