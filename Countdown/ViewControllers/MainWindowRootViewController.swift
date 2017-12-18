//
//  ViewController.swift
//  Countdown
//
//  Created by Yan Li on 16/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Cocoa

class MainWindowRootViewController: NSViewController {
    
    private var rootNode: FileSystemNode?
    private var scanner: FileScanner?
    private weak var fileBrowserViewController: FileBrowserViewController?
    private weak var statusBarViewController: StatusBarViewController?
    private var previousUpdate = Date()
    
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
        rootNode = FileSystemNode(url: url)
        scanner = FileScanner(fileURL: url)
        scanner?.delegate = self
        FileScanner.Queue.scanning.async {
            self.scanner?.start()
        }
    }
    
    func fileScannerDidStartScanning(_ scanner: FileScanner) {
        DispatchQueue.main.async {
            self.statusBarViewController?.updateStatus(to: .scanning)
        }
    }
    
    private static let updateInterval: TimeInterval = 0.5
    
    func fileScanner(_ scanner: FileScanner, didScanFileAt url: URL) {
        FileScanner.Queue.indexing.async {
            let node = FileSystemNode(url: url)
            self.rootNode?.addNodeToNearestParent(node)
            
            let now = Date()
            if now.timeIntervalSince(self.previousUpdate) > MainWindowRootViewController.updateInterval,
               let node = self.rootNode {
                self.previousUpdate = now
                DispatchQueue.main.async {
                    self.fileBrowserViewController?.display(node: node)
                }
            }
        }
    }
    
    func fileScannerDidFinishScanning(_ scanner: FileScanner, elapsedTime: TimeInterval) {
        DispatchQueue.main.async {
            if let node = self.rootNode {
                self.fileBrowserViewController?.display(node: node)
            }
            self.statusBarViewController?.updateStatus(to: .finished(elapsedTime))
            self.scanner = nil
        }
    }
}
