//
//  ParkingCalendarEvent.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/23/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

final class ParkingCalendarEvent: CustomStringConvertible {
    static var goodKeys = ["DESCRIPTION", "SUMMARY;LANGUAGE=en-us", "DTSTART;TZID=\"Eastern Standard Time\"", "DTEND;TZID=\"Eastern Standard Time\"", "DTSTART;VALUE=DATE", "DTEND;VALUE=DATE", "UID"]

    var date: Date = Date()
    var dateString: String = ""
    var fullMessage: String = ""
    lazy var message: String = {
        let dePrefixed = self.fullMessage.replacingOccurrences(of: "Alternate Side Parking suspended for ", with: "")
        var deSuffixed = dePrefixed.replacingOccurrences(of: ". Parking meters will be in effect.", with: "")
        deSuffixed = deSuffixed.replacingOccurrences(of: ". Parking meters remain in effect.", with: "")
        deSuffixed = deSuffixed.replacingOccurrences(of: ". Parking meters will not be in effect. Stopping, standing and parking are permitted, except in areas where stopping, standing and parking rules are in effect seven days a week (for example, “No Standing Anytime”).", with: "")
        
        var returnString = deSuffixed
        let index = returnString.index(returnString.startIndex, offsetBy: 3)
        if returnString.substring(to: index) == "the" {
            returnString = returnString.replacingOccurrences(of: "the", with: "The")
        }
        
        return returnString
    }()
    var summary: String = "Alternate Side Parking Suspended"
    var uidRaw: String = ""
    var uid: String { return "\(dateString)ASP@dot.nyc.gov" }

    init(dictionary: [String : String]) {
        for (key, value) in dictionary {
            switch key {
            case "DESCRIPTION":
                fullMessage = value.replacingOccurrences(of: "\\n", with: "").replacingOccurrences(of: "\\,", with: ",")
                fullMessage = fullMessage.replacingOccurrences(of: "  ", with: " ")
                fullMessage = fullMessage.replacingOccurrences(of: "\"No Standing Anytime\"", with: "“No Standing Anytime”")
                fullMessage = fullMessage.replacingOccurrences(of: "effect.Stopping", with: "effect. Stopping")
                fullMessage = fullMessage.replacingOccurrences(of: "week(for", with: "week (for")
                fullMessage = fullMessage.replacingOccurrences(of: "stopping,standing", with: "stopping, standing")
            case "DTSTART;TZID=\"Eastern Standard Time\"", "DTSTART;VALUE=DATE":
                // ex. "20161225T000000"
                let index = value.index(value.startIndex, offsetBy: 8)
                let string = value.substring(to: index)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                date = formatter.date(from: string)!
                dateString = string
            case "SUMMARY;LANGUAGE=en-us":
                if !value.isEmpty && value != summary {
                    summary = value
                }
            case "UID":
                uidRaw = value
            default:
                // no op
                break
            }
        }
    }
    
    var description: String {
        return String(describing: date) + " " + message
    }
    
    func asJSON() -> String {
        return "{\n\"DESCRIPTION\": \"\(fullMessage)\",\n \"DTSTART\": \"\(dateString)\",\n \"SUMMARY\": \"\(summary)\",\n \"TITLE\": \"\(message)\",\n \"UID\": \"\(uid)\"\n}"
    }
}
