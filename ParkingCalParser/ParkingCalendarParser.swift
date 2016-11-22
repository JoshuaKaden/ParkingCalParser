//
//  ParkingCalendarParser.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

final class ParkingCalendarParser {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func parse(completion: (Result<ParseResults>) -> Void) {
        completion(.success(ParseResults()))
    }
}
