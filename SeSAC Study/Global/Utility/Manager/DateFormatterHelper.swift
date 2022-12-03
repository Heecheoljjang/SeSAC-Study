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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter
    }()
    
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
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .todayChat:
            dateFormatter.dateFormat = "a hh:mm"
        case .notTodayChat:
            dateFormatter.dateFormat = "MM/dd a hh:mm"
        }
        guard let date = dateFormatter.date(from: string) else {
            print("못바꿨어")
            return Date() }
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
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .todayChat:
            dateFormatter.dateFormat = "a hh:mm"
        case .notTodayChat:
            dateFormatter.dateFormat = "MM/dd a hh:mm"
        }
        return dateFormatter.string(from: date)
    }
    
    func chatDateText(dateString: String) -> String {
        let date = stringToDate(string: dateString, type: .dateString)
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return dateToString(date: date, type: .todayChat)
        } else {
            return dateToString(date: date, type: .notTodayChat)
        }
    }
}
