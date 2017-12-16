//
//  FileBrowserViewController.swift
//  Countdown
//
//  Created by Yan Li on 16/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Cocoa

class FileBrowserViewController: NSViewController {

    @IBOutlet private weak var fileBrowser: NSBrowser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

private extension FileBrowserViewController {
    
    private func setUpViews() {
        // hide bezels
        fileBrowser.isTitled = false
        fileBrowser.separatesColumns = false
        // make resizable
        fileBrowser.columnResizingType = .userColumnResizing
    }
}
