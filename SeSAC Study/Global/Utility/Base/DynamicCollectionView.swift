//
//  DynamicCollectionView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/19.
//
import UIKit

class DynamicCollectionView: UICollectionView {
    override var intrinsicContentSize: CGSize {
      return self.contentSize
    }

    override var contentSize: CGSize {
      didSet {
          self.invalidateIntrinsicContentSize()
      }
    }
}
