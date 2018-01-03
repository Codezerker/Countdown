//
//  MainWindowController.swift
//  Countdown
//
//  Created by Yan Li on 3/01/18.
//  Copyright © 2018 Codezerker. All rights reserved.
//

import AppKit

class MainWindow: NSWindow {}

class MainWindowController: NSWindowController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpToolbar()
    }
}

private extension MainWindowController {
    
    private struct ToolbarIdentifiers {
        static let `default` = NSToolbar.Identifier(rawValue: "com.codezerker.countdown.toolbar")
    }
    
    private func setUpToolbar() {
        let toolbar = NSToolbar(identifier: ToolbarIdentifiers.default)
        toolbar.allowsUserCustomization = false
        toolbar.delegate = self
        window?.toolbar = toolbar
    }
}

extension MainWindowController: NSToolbarDelegate {
    
    private struct ToolbarItemIdentifiers {
        static let scan = NSToolbarItem.Identifier(rawValue: "com.codezerker.countdown.toolbar.scan")
        static let stop = NSToolbarItem.Identifier(rawValue: "com.codezerker.countdown.toolbar.stop")
        static let log = NSToolbarItem.Identifier(rawValue: "com.codezerker.countdown.toolbar.log")
        
        static var `default`: [NSToolbarItem.Identifier] {
            return [
                scan,
                stop,
                .flexibleSpace,
                log,
            ]
        }
        
        static var all: [NSToolbarItem.Identifier] {
            return [
                scan,
                stop,
                log,
                .flexibleSpace,
                .space,
            ]
        }
    }
    
    private typealias ToolbarItemInfo = (
        title: String,
        iconImageName: NSImage.Name,
        tag: Int,
        action: Selector
    )
    
    private static let itemInfoMap: [NSToolbarItem.Identifier : ToolbarItemInfo] = [
        ToolbarItemIdentifiers.scan : ToolbarItemInfo(title: "Scan",
                                                      iconImageName: NSImage.Name(rawValue: "FolderTemplate"),
                                                      tag: ActionItemTag.start,
                                                      action: #selector(MainWindowRootViewController.scanFolderClicked)),
        ToolbarItemIdentifiers.stop : ToolbarItemInfo(title: "Stop",
                                                      iconImageName: NSImage.Name.stopProgressTemplate,
                                                      tag: ActionItemTag.stop,
                                                      action: #selector(MainWindowRootViewController.stopScan)),
        ToolbarItemIdentifiers.log : ToolbarItemInfo(title: "Log",
                                                     iconImageName: NSImage.Name(rawValue: "InfoTemplate"),
                                                     tag: ActionItemTag.showLog,
                                                     action: #selector(MainWindowRootViewController.toggleLog)),
    ]
    
    private func button(with toolbarItemInfo: ToolbarItemInfo) -> NSButton {
        let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 28))
        button.title = ""
        button.image = NSImage(named: toolbarItemInfo.iconImageName)
        button.bezelStyle = .texturedRounded
        return button
    }
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        guard let toolbarItemInfo = MainWindowController.itemInfoMap[itemIdentifier] else {
            return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
        
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        toolbarItem.label = toolbarItemInfo.title
        toolbarItem.view = button(with: toolbarItemInfo)
        toolbarItem.tag = toolbarItemInfo.tag
        toolbarItem.target = contentViewController
        toolbarItem.action = toolbarItemInfo.action
        return toolbarItem
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return ToolbarItemIdentifiers.default
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return ToolbarItemIdentifiers.all
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        // ...
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        // ...
    }
}