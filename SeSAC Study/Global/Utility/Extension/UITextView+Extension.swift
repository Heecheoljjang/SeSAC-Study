//
//  UITextView+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/29.
//

import UIKit

extension UITextView {
    func checkNumberOfLines() -> Int {
        let textContainerHeight = self.textContainer.size.height
        guard let lineHeight = self.font?.lineHeight else { return 0 }
        
        return Int(textContainerHeight / lineHeight)
    }
}
