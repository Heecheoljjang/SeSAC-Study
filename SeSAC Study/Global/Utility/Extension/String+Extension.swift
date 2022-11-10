//
//  String+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/08.
//

import Foundation

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
            print("1")
            if let regex = try? NSRegularExpression(pattern: "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{1,4})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self),withTemplate: "$1$2$3-$4")
                return modString
            }
        }
        
        if self.count >= 7 {
            print("2")
            if let regex = try? NSRegularExpression(pattern: "([0-9]{1})([0-9]{1})([0-9]{1})([0-9]{3,4})([0-9]{1})", options: .caseInsensitive) {
                let modString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(self.startIndex..., in: self),withTemplate: "$1$2$3-$4-$5")
                return modString
            }
        }
        return self
    }
}
