//
//  ShopTabmanView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import Tabman

final class ShopTabmanView: BaseView {
    
    let barItem = [
        TMBarItem(title: ShopVC.sesac.title),
        TMBarItem(title: ShopVC.background.title)
    ]
    let buttonBar: TMBar.ButtonBar = {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.buttons.customize { button in
            button.tintColor = .graySix
            button.selectedTintColor = .brandGreen
        }
        bar.indicator.tintColor = .brandGreen
        bar.indicator.weight = .light
        bar.systemBar().backgroundStyle = .clear
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
}
