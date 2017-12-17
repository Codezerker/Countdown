//
//  NSViewController+Extensions.swift
//  Countdown
//
//  Created by Yan Li on 17/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import AppKit

extension NSViewController {
    
    func childViewControllers<T>(ofType type: T.Type) -> [T] where T: NSViewController {
        return childViewControllers.filter { $0 is T } as! [T]
    }
}
