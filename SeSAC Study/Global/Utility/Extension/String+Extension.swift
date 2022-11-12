//
//  String+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/08.
//

import Foundation
import UIKit

extension String {
    
    subscript(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        
        let result = index(startIndex, offsetBy: idx)
        return String(self[result])
    }
        
    func changeFormat() -> String {
        var temp = self
        temp.removeFirst()
        return "+82\(temp)"
    }
}

extension String {
    
    func pretty() -> String {
        if self.count > 3 && self.count <= 6{
            if let regex = try? NSRegularExpression(pattern: "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1,4})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self),withTemplate: "$1$2$3-$4")
                return modString
            }
        }
        
        if self.count == 10 {
            if let regex = try? NSRegularExpression(pattern: "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{3})([0-9]{4})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self),withTemplate: "$1$2$3-$4-$5")
                return modString
            }
        }
        
        if self.count >= 7 {
            if let regex = try? NSRegularExpression(pattern: "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{3,4})([0-9]{1})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self),withTemplate: "$1$2$3-$4-$5")
                return modString
            }
        }
        return self
    }
    
    func stringToDate(type: DateString) -> Date {
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
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        }
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
    func makeAttributedSpacing(spacing: CGFloat, colorText: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.font, value: UIFont(name: CustomFont.regular, size: 24), range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.brandGreen, range: (self as NSString).range(of: colorText))
        return attributedString
    }
}
