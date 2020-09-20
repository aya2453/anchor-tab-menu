//
//  AnchorTabMenuSampleViewController.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/19.
//  Copyright © 2020 aya2453. All rights reserved.
//

import UIKit

final class AnchorTabMenuSampleViewController: AnchorTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "AnchorTabMenuContent", bundle: nil)
        let controller = sb.instantiateViewController(identifier: "UICollectionViewTabTableViewController")
        contentViewController = controller as! UICollectionViewTabTableViewController
    }
}

