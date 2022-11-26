//
//  AroundSesacTableViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit

final class AroundSesacTableViewCell: ProfileTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: AroundSesacTableViewCell.identifier)
        
        var title = AttributedString.init(ButtonTitle.requestFriend)
        title.font = UIFont(name: CustomFont.regular, size: 14)
        requestButton.configuration?.attributedTitle = title
        requestButton.configuration?.baseBackgroundColor = .error
    }
}
