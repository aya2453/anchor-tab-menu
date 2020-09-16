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
    private let titles = ["Item1Item1", "Item2", "Item3Item3Item3", "Item4Item4Item4", "Item5"]
    
    private var indicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO:初期表示時に0番目のアイテムを選択状態にする
        let indicator = UIView(frame: CGRect(x: 0, y: collectionView.bounds.height - 3, width: 0, height: 3))
        indicator.layer.zPosition = 9999
        indicator.backgroundColor = .systemPink
        self.indicator = indicator
        collectionView.addSubview(indicator)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetItemFrame = collectionView.layoutAttributesForItem(at: indexPath)!.frame
        print(targetItemFrame)
        // BarViewのvisibleなwidthの半分から選択したアイテムの幅半分を引いて選択アイテムをセンタリングするxの値を求める
        let centerFrame = (collectionView.bounds.width / 2) - (targetItemFrame.width / 2)
        // スクロールした際のx軸最大値
        // スクリーンからはみ出した部分 = スクロールできる最大値
        let maxOffSetX = collectionView.contentSize.width - collectionView.bounds.width + collectionView.contentInset.right
        let minOffSetX = collectionView.contentInset.left
        // 選択したアイテムのxからセンタリングまでのxを引いて真ん中にくるようにする
        var contentOffset = CGPoint(x: (-centerFrame) + targetItemFrame.origin.x, y: 0.0)
        // スクロールがされない
        contentOffset.x = max(minOffSetX, min(contentOffset.x, maxOffSetX))
        print(centerFrame)
        collectionView.setContentOffset(contentOffset, animated: true)
        var indicatorFrame = indicator.frame
        indicatorFrame.size.width = targetItemFrame.size.width
        indicatorFrame.origin.x = targetItemFrame.origin.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.indicator.frame = indicatorFrame
        }
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
//        print(proposedContentOffset.x)
//        print(collectionView?.contentOffset)
        return proposedContentOffset
    }
}
