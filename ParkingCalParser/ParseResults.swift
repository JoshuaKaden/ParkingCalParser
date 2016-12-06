//
//  ParseResults.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

struct ParseResults {
    let sourceLines: [String]
    let eventDictionaries: [[String : String]]
    let events: [ParkingCalendarEvent]
    
    func asJSON() -> String {
        let eventsString = events
            .sorted(by: { $0.date < $1.date })
            .map { $0.asJSON() }
            .joined(separator: ",")
        return "{\"VCALENDAR\": {\"VEVENT\": [\(eventsString)]}}"
    }
    
    func splitByMonth() -> [[ParkingCalendarEvent]] {
        var months: [[ParkingCalendarEvent]] = []
        for _ in 0...11 {
            months.append([])
        }
        
        let calendar = Calendar.current
        events.forEach() {
            event in
            let monthIndex = calendar.component(.month, from: event.date) - 1
            months[monthIndex].append(event)
        }
        return months
    }
}
