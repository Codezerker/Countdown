//
//  URL+Extensions.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

extension URL {
    
    static var prefetchingPropertyKeys: [URLResourceKey] {
        return [
            .isDirectoryKey,
            .fileSizeKey,
            .localizedNameKey,
            .parentDirectoryURLKey,
        ]
    }
    
    var isDirectory: Bool {
        guard let values = try? resourceValues(forKeys: [.isDirectoryKey]),
              let isDirectory = values.isDirectory else {
            return false
        }
        return isDirectory
    }
    
    var fileSize: Int? {
        return (try? resourceValues(forKeys: [.fileSizeKey]))?.fileSize
    }
    
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    var parentDirectory: URL? {
        return (try? resourceValues(forKeys: [.parentDirectoryURLKey]))?.parentDirectory
    }
}
