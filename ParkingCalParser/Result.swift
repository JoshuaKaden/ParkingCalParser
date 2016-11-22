//
//  Result.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
