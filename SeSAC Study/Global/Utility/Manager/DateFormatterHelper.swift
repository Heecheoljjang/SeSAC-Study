//
//  DateFormatterManager.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/01.
//

import Foundation

final class DateFormatterHelper {
    private init() {}
    
    static let shared = DateFormatterHelper()
    
    let dateFormatter = DateFormatter()
    
    func stringToDate(string: String, type: DateString) -> Date {
        switch type {
        case .year:
            dateFormatter.dateFormat = "yyyy"
        case .month:
            dateFormatter.dateFormat = "M"
        case .day:
            dateFormatter.dateFormat = "d"
        case .date:
            dateFormatter.dateFormat = "yyyyMMdd"
        case .dateString:
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        }
        guard let date = dateFormatter.date(from: string) else { return Date() }
        return date
    }
    
    func dateToString(date: Date, type: DateString) -> String {
        switch type {
        case .year:
            dateFormatter.dateFormat = "yyyy"
        case .month:
            dateFormatter.dateFormat = "M"
        case .day:
            dateFormatter.dateFormat = "d"
        case .date:
            dateFormatter.dateFormat = "yyyyMMdd"
        case .dateString:
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        }
        return dateFormatter.string(from: date)
    }
}
