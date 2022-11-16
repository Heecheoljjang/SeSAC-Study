//
//  UITableViewCell+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
