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
        ]
    }
}
