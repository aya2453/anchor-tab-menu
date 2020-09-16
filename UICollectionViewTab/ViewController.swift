//
//  ViewController.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/15.
//  Copyright © 2020 aya2453. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = CustomLayout()
            collectionView.collectionViewLayout = flowLayout
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    let titles = ["Item1Item1", "Item2", "Item3Item3Item3", "Item4Item4Item4", "Item5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath)
        if let cell = cell as? MenuCollectionViewCell {
            cell.setUp(name: titles[indexPath.row], isSelected: indexPath.row == 0)
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = titles[indexPath.row]
        print(item)
        var size = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
            ]
        )
        // 左右10pxの余白を開ける
        size.width += 20
        // cellの高さをCollectionViewの高さと合わせる
        size.height = collectionView.frame.height
        return size
    }
}

final class CustomLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print(proposedContentOffset.x)
        return proposedContentOffset
    }
}
