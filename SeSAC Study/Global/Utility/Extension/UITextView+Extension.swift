//
//  UITextView+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/29.
//

import UIKit

extension UITextView {
    func checkNumberOfLines() -> Int {
        let textViewContentHeight = self.contentSize.height
        guard let lineHeight = self.font?.lineHeight else { return 1 }
        return Int(textViewContentHeight / lineHeight)
    }
}
