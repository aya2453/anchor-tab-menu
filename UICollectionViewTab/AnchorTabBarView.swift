//
//  AnchorTabBarView.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/19.
//  Copyright © 2020 aya2453. All rights reserved.
//

import UIKit

protocol AnchorTabBarViewDelegate: class {
    func didScroll(to: IndexPath)
}
class AnchorTabBarView: UICollectionView {
    
    static let layout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()

    
    private var indicator: UIView!
    weak var scrollDelegate: AnchorTabBarViewDelegate?

    let items: KeyValuePairs = ["Item1Item1": 2, "Item2": 3, "Item3Item3Item3" :1, "Item4Item4Item4": 2, "Item5" : 2]

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    private func setup() {
        register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        dataSource = self
        delegate = self
        let indicator = UIView(frame: CGRect(x: 0, y: bounds.height - 3, width: 0, height: 3))
        indicator.backgroundColor = .systemPink
        self.indicator = indicator
        addSubview(indicator)
//        let borderBottom = CALayer()
//        borderBottom.backgroundColor = UIColor.gray.cgColor
//        borderBottom.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
//        layer.addSublayer(borderBottom)
//        self.layer.masksToBounds = true
    }
}

extension AnchorTabBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath)
        if let cell = cell as? MenuCollectionViewCell {
            cell.setUp(name: items[indexPath.row].key)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setup(indexPath: indexPath)
        let indexPath2 = IndexPath(row: 0, section: indexPath.row)
        scrollDelegate?.didScroll(to: indexPath2)
    }
}

extension AnchorTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row].key
        var size = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)
            ]
        )
        // 左右10pxの余白を開ける
        size.width += 20
        // cellの高さをCollectionViewの高さと合わせる
        size.height = collectionView.frame.height
        return size
    }
}

extension AnchorTabBarView: UICollectionViewTabTableViewControllerDelegate {
    func dispatchScroll(to indexPath: IndexPath) {
       setup(indexPath: indexPath)
    }
}

extension AnchorTabBarView {
    private func setup(indexPath: IndexPath) {
        let targetItemFrame = layoutAttributesForItem(at: indexPath)!.frame
        // BarViewのvisibleなwidthの半分から選択したアイテムの幅半分を引いて選択アイテムをセンタリングするxの値を求める
        let centerFrame = (bounds.width / 2) - (targetItemFrame.width / 2)
        // スクロールした際のx軸最大値
        // スクリーンからはみ出した部分 = スクロールできる最大値
        let maxOffSetX = contentSize.width - bounds.width + contentInset.right
        let minOffSetX = contentInset.left
        // 選択したアイテムのxからセンタリングまでのxを引いて真ん中にくるようにする
        var contentOffset = CGPoint(x: (-centerFrame) + targetItemFrame.origin.x, y: 0.0)
        // はみ出さないようにする
        contentOffset.x = max(minOffSetX, min(contentOffset.x, maxOffSetX))
        setContentOffset(contentOffset, animated: true)
        var indicatorFrame = indicator.frame
        indicatorFrame.size.width = targetItemFrame.size.width
        indicatorFrame.origin.x = targetItemFrame.origin.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.indicator.frame = indicatorFrame
        }
    }
}
