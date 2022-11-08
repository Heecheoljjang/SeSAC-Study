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
