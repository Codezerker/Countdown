//
//  StatusBarViewController.swift
//  Countdown
//
//  Created by Yan Li on 16/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Cocoa

enum FileSystemScanStatus {
    case none
    case scanning
    case finished(TimeInterval)
}
    
class StatusBarViewController: NSViewController {
    
    @IBOutlet private weak var separatorView: NSView!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var hintLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        separatorView.wantsLayer = true
        separatorView.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        updateStatus(to: .none)
    }
    
    func updateStatus(to status: FileSystemScanStatus) {
        switch status {
        case .none:
            progressIndicator.stopAnimation(nil)
            hintLabel.isHidden = true
        case .scanning:
            progressIndicator.startAnimation(nil)
            hintLabel.isHidden = false
            hintLabel.stringValue = "Scanning…"
        case .finished(let timeInterval):
            progressIndicator.stopAnimation(nil)
            hintLabel.isHidden = false
            hintLabel.stringValue = "Scan finished after \(timeInterval) seconds."
        }
    }
}
