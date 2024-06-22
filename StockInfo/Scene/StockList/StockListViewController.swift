//
//  StockListViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import SnapKit
import UIKit

class StockListViewController: BaseViewController<StockListViewModel> {
    lazy var pageListView: PageListView = {
        let view = PageListView()
        view.backgroundColor = SColor.backgroundColor1
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI

extension StockListViewController {
    func setupUI() {
        view.addSubview(pageListView)
        pageListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
}

// MARK: - PageListViewDelegate

extension StockListViewController: PageListViewDelegate {
    func pageDidSelected(item _: any PageItemProtocol) {}
}
