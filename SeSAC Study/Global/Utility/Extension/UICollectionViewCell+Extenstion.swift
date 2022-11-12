//
//  UICollectionViewCell+Extenstion.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
