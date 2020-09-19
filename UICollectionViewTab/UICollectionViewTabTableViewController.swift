//
//  UICollectionViewTabTableViewController.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/17.
//  Copyright © 2020 aya2453. All rights reserved.
//

import UIKit

protocol UICollectionViewTabTableViewControllerDelegate: class {
    func dispatchScroll(to indexPath: IndexPath)
}

final class UICollectionViewTabTableViewController: UITableViewController {
    
    weak var viewControllerDelegate: UICollectionViewTabTableViewControllerDelegate?
    
    let items: KeyValuePairs = ["Item1Item1": 2, "Item2": 3, "Item3Item3Item3" :1, "Item4Item4Item4": 2, "Item5" : 2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UICollectionViewTabCell", bundle: nil), forCellReuseIdentifier: "UICollectionViewTabCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section != 0 {
            return
        }
        guard let visibleCells = tableView.indexPathsForVisibleRows else {
            return
        }
        let firstVisibleSectionIndexPath = visibleCells[0]
        if firstVisibleSectionIndexPath.section == section {
             viewControllerDelegate?.dispatchScroll(to: IndexPath(row: 0, section: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].value
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        items[section].key
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UICollectionViewTabCell", for: indexPath)
        if let cell = cell as? UICollectionViewTabCell {
            cell.setup()
        }
        return cell
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dispatchDidEndScroll()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dispatchDidEndScroll()
    }
    
    private func dispatchDidEndScroll() {
        if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height) {
            // bottomまでscrollしていた場合は最後のアイテムを選択アイテムとする
            viewControllerDelegate?.dispatchScroll(to: IndexPath(row: items.count - 1, section: 0))
            return
        }
        guard let visibleCells = tableView.indexPathsForVisibleRows else {
            return
        }
        viewControllerDelegate?.dispatchScroll(to: IndexPath(row: visibleCells[0].section, section: 0))
    }
}
