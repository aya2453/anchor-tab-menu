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
    
    func setUp(name: String, isSelected: Bool) {
        titleLabel.text = name
        if isSelected {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.indicatorView.backgroundColor = .red
                    self.layoutIfNeeded()
                }
            }
        } else {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupIndicatorView()
    }
    
    
    func setupIndicatorView() {
        indicatorView = UIView()
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            indicatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


