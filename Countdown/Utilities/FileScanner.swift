//
//  FileScanner.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

protocol FileScannerDelegate: class {
    func fileScannerDidStartScanning(_ scanner: FileScanner)
    func fileScanner(_ scanner: FileScanner, didScanFileAt url: URL)
    func fileScannerDidFinishScanning(_ scanner: FileScanner, elapsedTime: TimeInterval)
}

class FileScanner {
    
    let fileURL: URL
    weak var delegate: FileScannerDelegate?
    
    private static let scanningQueue = DispatchQueue(label: "com.codezerker.countdown.scanning")
    private var directoryEnumerator: FileManager.DirectoryEnumerator?
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func start() {
        directoryEnumerator = FileManager.default.enumerator(at: fileURL,
                                                             includingPropertiesForKeys: URL.prefetchingPropertyKeys,
                                                             options: [.skipsPackageDescendants],
                                                             errorHandler: { url, error in
                                                                 // ...
                                                                 return true
                                                             })
        FileScanner.scanningQueue.async {
            let startedAt = Date()
            self.delegate?.fileScannerDidStartScanning(self)
            while let url = self.directoryEnumerator?.nextObject() as? URL {
                self.delegate?.fileScanner(self, didScanFileAt: url)
            }
            self.delegate?.fileScannerDidFinishScanning(self, elapsedTime: Date().timeIntervalSince(startedAt))
        }
    }
}
