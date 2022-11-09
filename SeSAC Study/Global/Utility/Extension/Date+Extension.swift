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
        }
        return dateFormatter.string(from: self)
    }
    
    func compareYear() -> Bool {
        let today = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let birthday = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        if today.year! - birthday.year! > 17 {
            return true
        }
        if today.year! - birthday.year! < 17 {
            return false
        }
        if today.month! < birthday.month! {
            return false
        }
        if today.month! > birthday.month! {
            return true
        }
        
        if today.day! < birthday.day! {
            return false
        }
        return true
    }
}
