//
//  VerticallyCenteredTextView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/29.
//

import UIKit

class VerticallyCenteredTextView: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
    
        let rect = layoutManager.usedRect(for: textContainer)
        let topInset = (bounds.size.height - rect.height) / 2.0
        textContainerInset.top = max(0, topInset)
    }
}
