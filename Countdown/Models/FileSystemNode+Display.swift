//
//  FileSystemNode+AppKit.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit

extension FileSystemNode {
    
    var displayName: String {
        return url.localizedName ?? url.lastPathComponent
    }
    
    var displayIcon: NSImage {
        return NSWorkspace.shared.icon(forFile: url.path)
    }
}
