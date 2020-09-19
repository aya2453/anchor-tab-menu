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
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = flowLayout
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    private var isEnabled = true
    private var selectedIndex: IndexPath?

   let items: KeyValuePairs = ["Item1Item1": 2, "Item2": 3, "Item3Item3Item3" :1, "Item4Item4Item4": 2, "Item5" : 2]
    
    private var indicator: UIView!
    
    
    private var tableViewController: UICollectionViewTabTableViewController! {
        didSet {
            tableViewController.viewControllerDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicator = UIView(frame: CGRect(x: 0, y: collectionView.bounds.height - 3, width: 0, height: 3))
        indicator.backgroundColor = .systemPink
        self.indicator = indicator
        collectionView.addSubview(indicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as UICollectionViewTabTableViewController:
            tableViewController = vc
        default:
            break
        }
    }
}

extension ViewController: UICollectionViewDataSource {
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
        tableViewController.tableView.scrollToRow(at: indexPath2, at: .top, animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row].key
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

extension ViewController: UICollectionViewTabTableViewControllerDelegate {
    func dispatchScroll(to indexPath: IndexPath) {
       setup(indexPath: indexPath)
    }
}

extension ViewController {
    private func setup(indexPath: IndexPath) {
        let targetItemFrame = collectionView.layoutAttributesForItem(at: indexPath)!.frame
        // BarViewのvisibleなwidthの半分から選択したアイテムの幅半分を引いて選択アイテムをセンタリングするxの値を求める
        let centerFrame = (collectionView.bounds.width / 2) - (targetItemFrame.width / 2)
        // スクロールした際のx軸最大値
        // スクリーンからはみ出した部分 = スクロールできる最大値
        let maxOffSetX = collectionView.contentSize.width - collectionView.bounds.width + collectionView.contentInset.right
        let minOffSetX = collectionView.contentInset.left
        // 選択したアイテムのxからセンタリングまでのxを引いて真ん中にくるようにする
        var contentOffset = CGPoint(x: (-centerFrame) + targetItemFrame.origin.x, y: 0.0)
        // はみ出さないようにする
        contentOffset.x = max(minOffSetX, min(contentOffset.x, maxOffSetX))
        collectionView.setContentOffset(contentOffset, animated: true)
        var indicatorFrame = indicator.frame
        indicatorFrame.size.width = targetItemFrame.size.width
        indicatorFrame.origin.x = targetItemFrame.origin.x
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.indicator.frame = indicatorFrame
        }
    }
}
