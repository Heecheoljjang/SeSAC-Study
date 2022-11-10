//
//  Date+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation

extension Date {
    
    func dateToString(type: DateString) -> String {
        let dateFormatter = DateFormatter()
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
            dateFormatter.dateFormat = "YYYY-MM-DDTHH:mm:ss.SSSZ"
        }
        return dateFormatter.string(from: self)
    }
    
    func compareYear() -> Bool {
    
        let calendar = Calendar(identifier: .gregorian)
        let current = Date().dateToString(type: .date)
        guard let selectedDate = calendar.date(byAdding: .year, value: 17, to: self)?.dateToString(type: .date) else { return false }
        return current >= selectedDate
    }
}
