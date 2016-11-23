//
//  ParkingCalendarEvent.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/23/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

final class ParkingCalendarEvent: CustomStringConvertible {
    static var goodKeys = ["DESCRIPTION", "SUMMARY;LANGUAGE=en-us", "DTSTART;TZID=\"Eastern Standard Time\"", "DTEND;TZID=\"Eastern Standard Time\"", "UID"]

    var date: Date = Date()
    var fullMessage: String = ""
    lazy var message: String = {
        let deLineFed = self.fullMessage.replacingOccurrences(of: "\\n", with: "")
        let dePrefixed = deLineFed.replacingOccurrences(of: "Alternate Side Parking suspended for ", with: "")
        var deSuffixed = dePrefixed.replacingOccurrences(of: ". Parking meters will be in effect.", with: "")
        deSuffixed = deSuffixed.replacingOccurrences(of: ". Parking meters remain in effect.", with: "")
        deSuffixed = deSuffixed.replacingOccurrences(of: ". Parking meters will not be in effect. Stopping\\, standing and parking are permitted\\, except in areas where stopping\\, standing and parking rules are in effect seven days a week (for example\\, “No Standing Anytime”).", with: "")
        return deSuffixed.capitalized
    }()
    
    init(dictionary: [String : String]) {
        for (key, value) in dictionary {
            switch key {
            case "DESCRIPTION":
                fullMessage = value
            case "DTSTART;TZID=\"Eastern Standard Time\"":
                // ex. "20161225T000000"
                let index = value.index(value.startIndex, offsetBy: 8)
                let string = value.substring(to: index)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                date = formatter.date(from: string)!
            default:
                // no op
                break
            }
        }
    }
    
    var description: String {
        return String(describing: date) + " " + message
    }
}
