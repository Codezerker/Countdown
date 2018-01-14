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
    @IBOutlet private weak var pathControl: NSPathControl!
    
    private var displayingNode: FileSystemNode?
    private let formatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func display(node: FileSystemNode?) {
        if displayingNode == nil {
            displayingNode = node
            fileBrowser.loadColumnZero()
            pathControl.url = node?.url
        } else {
            displayingNode = node
            for i in 0...fileBrowser.lastColumn {
                fileBrowser.reloadColumn(i)
            }
        }
    }
    
    func clearContents() {
        displayingNode = nil
        fileBrowser.loadColumnZero()
        pathControl.url = nil
    }
}

extension FileBrowserViewController {
    
    var showInFinderEnabled: Bool {
        return fileBrowser.selectedCell() != nil
    }
    
    func openSelectedNodeInFinder() {
        guard let selectedCell = fileBrowser.selectedCell() as? FileSystemBrowserCell,
              let selectedNode = selectedCell.displayingNode else {
            return
        }
        NSWorkspace.shared.activateFileViewerSelecting([selectedNode.url])
    }
}

private extension FileBrowserViewController {
    
    private struct Layout {
        static let columnWidth: CGFloat = 200
        static let rowHeight: CGFloat = 18
    }
    
    private func setUpViews() {
        // hide bezels
        fileBrowser.isTitled = false
        fileBrowser.separatesColumns = false
        // make resizable
        fileBrowser.setDefaultColumnWidth(Layout.columnWidth)
        fileBrowser.columnResizingType = .userColumnResizing
        // set delegate
        fileBrowser.setCellClass(FileSystemBrowserCell.self)
        fileBrowser.delegate = self
        // set actions
        fileBrowser.target = self
        fileBrowser.action = #selector(fileBrowserClicked)
    }
    
    @IBAction private func fileBrowserClicked(_ sender: Any?) {
        guard let selectedCell = fileBrowser.selectedCell() as? FileSystemBrowserCell else {
            return
        }
        pathControl.url = selectedCell.displayingNode?.url
    }
}

extension FileBrowserViewController: NSBrowserDelegate {
    
    func rootItem(for browser: NSBrowser) -> Any? {
        return displayingNode
    }
    
    func browser(_ browser: NSBrowser, numberOfChildrenOfItem item: Any?) -> Int {
        guard let node = item as? FileSystemNode else {
            return 0
        }
        
        // assuming this method will only be called once for each node
        // sorting children with file size
        node.displayChildren.sort { $0.fileSize > $1.fileSize }
        
        return node.displayChildren.count
    }
    
    func browser(_ browser: NSBrowser, child index: Int, ofItem item: Any?) -> Any {
        guard let node = item as? FileSystemNode else {
            fatalError() // panic!! because we don't know what to do!!
        }
        if index > node.displayChildren.count {
            // FIXME: for some reason this can happen sometimes
            // return a invalid value to workaround,
            // as in the next refresh, the tree will be self-corrected
            return node
        }
        return node.displayChildren[index]
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
    
    func browser(_ sender: NSBrowser, willDisplayCell cell: Any, atRow row: Int, column: Int) {
        guard let cell = cell as? FileSystemBrowserCell,
              let node = fileBrowser.item(atRow: row, inColumn: column) as? FileSystemNode else {
            return
        }
        let byteCount = formatter.string(fromByteCount: Int64(node.fileSize))
        cell.title = "\(byteCount) - \(node.displayName)"
        cell.image = node.displayIcon
        cell.displayingNode = node
    }
    
    func browser(_ browser: NSBrowser, heightOfRow row: Int, inColumn columnIndex: Int) -> CGFloat {
        return Layout.rowHeight
    }
}
