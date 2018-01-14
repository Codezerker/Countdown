//
//  ButtonToolbarItem.swift
//  Countdown
//
//  Created by Yan Li on 14/01/18.
//  Copyright © 2018 Codezerker. All rights reserved.
//

import Cocoa

protocol ButtonToolbarItemValidator: class {
    func validateToolbarItem(_ item: ButtonToolbarItem) -> Bool
}

class ButtonToolbarItem: NSToolbarItem {

    weak var validator: ButtonToolbarItemValidator?
    
    var button: NSButton? {
        return view as? NSButton
    }
    
    override func validate() {
        button?.isEnabled = validator?.validateToolbarItem(self) ?? false
    }
}
