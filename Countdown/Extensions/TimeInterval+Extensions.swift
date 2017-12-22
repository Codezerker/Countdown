//
//  TimeInterval+Extensions.swift
//  Countdown
//
//  Created by Yan Li on 19/12/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var description: String {
        var dateComponents = DateComponents()
        dateComponents.second = Int(self)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let result = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        var descriptions = [String]()
        if let hour = result.hour {
            switch hour {
            case 1:
                descriptions.append("\(hour) hour")
            case 2...:
                descriptions.append("\(hour) hours")
            default:
                break
            }
        }
        if let minute = result.minute {
            switch minute {
            case 1:
                descriptions.append("\(minute) minute")
            case 2...:
                descriptions.append("\(minute) minutes")
            default:
                break
            }
        }
        if let second = result.second {
            switch second {
            case 1:
                descriptions.append("\(second) second")
            case 2...:
                descriptions.append("\(second) seconds")
            default:
                break
            }
        }
        
        return descriptions.isEmpty ? "instantly" :
                                      "with " + descriptions.joined(separator: " ")
    }
}
