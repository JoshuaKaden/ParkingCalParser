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
}
