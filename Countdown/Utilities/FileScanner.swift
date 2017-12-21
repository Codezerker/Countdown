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
    var isRunning: Bool {
        return shouldContinue
    }
    
    private var directoryEnumerator: FileManager.DirectoryEnumerator?
    private var shouldContinue: Bool = false
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func start() {
        directoryEnumerator = FileManager.default.enumerator(at: fileURL,
                                                             includingPropertiesForKeys: URL.prefetchingPropertyKeys,
                                                             options: [],
                                                             errorHandler: { url, error in
                                                                 // TODO: handle error
                                                                 return true
                                                             })
        
        shouldContinue = true
        
        let startedAt = Date()
        delegate?.fileScannerDidStartScanning(self)
        while shouldContinue, let url = directoryEnumerator?.nextObject() as? URL {
            delegate?.fileScanner(self, didScanFileAt: url)
        }
        delegate?.fileScannerDidFinishScanning(self, elapsedTime: Date().timeIntervalSince(startedAt))
    }
    
    func stop() {
        shouldContinue = false
    }
}
