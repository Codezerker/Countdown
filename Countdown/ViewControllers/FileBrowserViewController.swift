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
    private var displayingNode: FileSystemNode?
    private let formatter = ByteCountFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func display(node: FileSystemNode) {
        displayingNode = node
        fileBrowser.loadColumnZero()
    }
}

extension FileBrowserViewController: NSBrowserDelegate {
    
    private func setUpViews() {
        // hide bezels
        fileBrowser.isTitled = false
        fileBrowser.separatesColumns = false
        // make resizable
        fileBrowser.setDefaultColumnWidth(200)
        fileBrowser.columnResizingType = .userColumnResizing
        // set delegate
        fileBrowser.delegate = self
    }
    
    func rootItem(for browser: NSBrowser) -> Any? {
        return displayingNode
    }
    
    func browser(_ browser: NSBrowser, numberOfChildrenOfItem item: Any?) -> Int {
        guard let node = item as? FileSystemNode else {
            return 0
        }
        return node.children.count
    }
    
    func browser(_ browser: NSBrowser, child index: Int, ofItem item: Any?) -> Any {
        guard let node = item as? FileSystemNode else {
            fatalError() // panic!! because we don't know what to do!!
        }
        return node.sortedChildren[index]
    }
    
    func browser(_ browser: NSBrowser, isLeafItem item: Any?) -> Bool {
        guard let node = item as? FileSystemNode else {
            return true
        }
        return !node.isDirectory
    }
    
    func browser(_ browser: NSBrowser, objectValueForItem item: Any?) -> Any? {
        guard let node = item as? FileSystemNode else {
            return nil
        }
        let byteCount = formatter.string(fromByteCount: Int64(node.fileSize))
        return "\(byteCount) - \(node.displayName)"
    }
}
