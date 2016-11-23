//
//  ParkingCalendarParser.swift
//  ParkingCalParser
//
//  Created by Joshua Kaden on 11/22/16.
//  Copyright © 2016 nycdoitt. All rights reserved.
//

import Foundation

enum ParkingCalendarParserError: Error {
    case fileNotFound, encoding
}

final class ParkingCalendarParser {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func parse(completion: (Result<ParseResults>) -> Void) {
        let lines: [String]
        do {
            lines = try fetchLines(url: url)
        } catch let error {
            completion(.error(error))
            return
        }
        
        let lineDictionaries = parse(lines: lines)
        let eventDictionaries = exciseIrrelevantKeys(dictionaries: lineDictionaries)
        let events = eventDictionaries.map { ParkingCalendarEvent(dictionary: $0) }
        
        let results = ParseResults(sourceLines: lines, eventDictionaries: eventDictionaries, events: events)
        completion(.success(results))
    }
    
    private func fetchLines(url: URL) throws -> [String] {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ParkingCalendarParserError.fileNotFound
        }
        
        guard let string = String(data: data, encoding: String.Encoding.utf8) else { throw ParkingCalendarParserError.encoding }
        
        return string.replacingOccurrences(of: "\r\n\t", with: "").components(separatedBy: "\r\n")
    }
    
    private func parse(lines: [String]) -> [[String : String]] {
        var dictionaries: [[String : String]] = []
        
        var inAlarm = false
        var inCalendar = false
        var inEvent = false
        
        var dictionary: [String : String] = [:]
        for line in lines {
            switch line {
            case "BEGIN:VCALENDAR":
                inCalendar = true
                continue
            case "END:VCALENDAR":
                inCalendar = false
                continue
            case "BEGIN:VEVENT":
                inEvent = true
                continue
            case "END:VEVENT":
                inEvent = false
                dictionaries.append(dictionary)
                dictionary = [:]
                continue
            case "BEGIN:VALARM":
                inAlarm = true
                continue
            case "END:VALARM":
                inAlarm = false
                continue
            default:
                break
            }
            
            if inAlarm {
                continue
            }
            
            if inCalendar && inEvent {
                let keyValueArray = line.components(separatedBy: ":")
                dictionary[keyValueArray[0]] = keyValueArray[1]
            }
        }
        
        return dictionaries
    }
    
    private func exciseIrrelevantKeys(dictionaries: [[String : String]]) -> [[String : String]] {
        let goodKeys = ParkingCalendarEvent.goodKeys
        
        var cleanedDictionaries: [[String : String]] = []
        for dictionary in dictionaries {
            var cleanedDictionary: [String : String] = [:]
            for (key, value) in dictionary {
                if goodKeys.contains(key) {
                    cleanedDictionary[key] = value
                }
            }
            cleanedDictionaries.append(cleanedDictionary)
        }
        
        return cleanedDictionaries
    }
}
