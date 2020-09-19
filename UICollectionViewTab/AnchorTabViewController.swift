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
    private var contentViewController: UICollectionViewTabTableViewController!
    
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
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                container.topAnchor.constraint(equalTo: view.topAnchor),
                container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    func addContent(tableViewController controller: UICollectionViewTabTableViewController) {
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
        controller.viewControllerDelegate = bar
        contentViewController = controller
    }
}

extension AnchorTabViewController: AnchorTabBarViewDelegate {
    func didScroll(to: IndexPath) {
        contentViewController.tableView.scrollToRow(at: to, at: .top, animated: true)
    }
}
