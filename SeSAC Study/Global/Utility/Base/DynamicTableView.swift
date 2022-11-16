//
//  DynamicTableView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/16.
//

import UIKit

//MARK: - 제대로 알아보기...
class DynamicTableView: UITableView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}
