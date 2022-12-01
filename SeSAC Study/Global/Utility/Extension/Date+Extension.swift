//
//  Date+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation

extension Date {
    func compareYear() -> Bool {
    
        let calendar = Calendar(identifier: .gregorian)
        let current = DateFormatterHelper.shared.dateToString(date: Date(), type: .date)

        guard let selectedDate = calendar.date(byAdding: .year, value: 17, to: self) else { return false }
        let selectedString = DateFormatterHelper.shared.dateToString(date: selectedDate, type: .date)

        return current >= selectedString
    }
}
