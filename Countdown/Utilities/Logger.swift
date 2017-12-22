//
//  Logger.swift
//  Countdown
//
//  Created by Yan Li on 22/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

struct Logger {
    
    static func log(message: String) {
        Queue.logging.async {
            NSLog(message)
        }
    }
}
