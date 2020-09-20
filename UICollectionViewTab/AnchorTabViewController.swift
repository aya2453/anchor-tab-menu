//
//  AnchorTabViewController.swift
//  UICollectionViewTab
//
//  Created by 中川彩 on 2020/09/19.
//  Copyright © 2020 aya2453. All rights reserved.
//

import UIKit

open class AnchorTabViewController: UIViewController {

    private let container = UIStackView()
    private var bar: AnchorTabBarView!
    var contentViewController: UICollectionViewTabTableViewController! {
        didSet {
            addChild(contentViewController)
            contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            container.addArrangedSubview(contentViewController.view)
            contentViewController.didMove(toParent: self)
            contentViewController.viewControllerDelegate = bar
        }
    }
    
    @IBOutlet private weak var contentView: UIView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        layoutContainer()
        addBar()
    }
    
    private func layoutContainer() {
        container.axis = .vertical
        container.alignment = .fill
        container.accessibilityIdentifier = "コンテナー"
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                container.topAnchor.constraint(equalTo: contentView.topAnchor),
                container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }

    private func addBar() {
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        bar = AnchorTabBarView(frame: rect, collectionViewLayout: AnchorTabBarView.layout)
        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([bar.heightAnchor.constraint(equalToConstant: 64)])
        container.addArrangedSubview(bar)
        bar.scrollDelegate = self
    }
}

extension AnchorTabViewController: AnchorTabBarViewDelegate {
    func didScroll(to: IndexPath) {
        contentViewController.tableView.scrollToRow(at: to, at: .top, animated: true)
    }
}
