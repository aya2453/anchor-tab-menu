//
//  MenuCollectionViewCell.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/15.
//  Copyright © 2020 aya2453. All rights reserved.
//

import Foundation
import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    private var indicatorView: UIView!
    
    func setUp(name: String) {
        titleLabel.text = name
    }

}


