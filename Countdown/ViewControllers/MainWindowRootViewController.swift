//
//  ViewController.swift
//  Countdown
//
//  Created by Yan Li on 16/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Cocoa

class MainWindowRootViewController: NSViewController {
    
    private var scanner: FileScanner?
    
    private weak var fileBrowserViewController: FileBrowserViewController?
    private weak var statusBarViewController: StatusBarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileBrowserViewController = childViewControllers(ofType: FileBrowserViewController.self).first
        statusBarViewController = childViewControllers(ofType: StatusBarViewController.self).first
    }
    
    @IBAction private func scanFolderClicked(_ sender: Any?) {
        guard scanner == nil,
              let window = view.window else {
            return
        }
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginSheetModal(for: window) { response in
            guard response == .OK,
                  let url = openPanel.url else {
                return
            }
            self.startScanner(at: url)
        }
    }
}

extension MainWindowRootViewController: FileScannerDelegate {
    
    private func startScanner(at url: URL) {
        scanner = FileScanner(fileURL: url)
        scanner?.delegate = self
        scanner?.start()
    }
    
    func fileScannerDidStartScanning(_ scanner: FileScanner) {
        DispatchQueue.main.async {
            self.statusBarViewController?.updateStatus(to: .scanning)
        }
    }
    
    func fileScanner(_ scanner: FileScanner, didScanFileAt url: URL) {
        // ...
    }
    
    func fileScannerDidFinishScanning(_ scanner: FileScanner, elapsedTime: TimeInterval) {
        DispatchQueue.main.async {
            self.statusBarViewController?.updateStatus(to: .finished(elapsedTime))
            self.scanner = nil
        }
    }
}
