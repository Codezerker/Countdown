//
//  Queue.swift
//  Countdown
//
//  Created by Yan Li on 21/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

struct Queue {
    static let scanning = DispatchQueue(label: "com.codezerker.countdown.scanning")
    static let indexing = DispatchQueue(label: "com.codezerker.countdown.indexing")
    static let sorting = DispatchQueue(label: "com.codezerker.countdown.sorting", attributes: [.concurrent])
}
