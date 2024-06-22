//
//  StockListViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Combine
import SnapKit
import UIKit

class StockListViewController: BaseViewController<StockListViewModel> {
    // MARK: - Property

    var cancelBags = Set<AnyCancellable>()

    // MARK: UI Component

    lazy var pageListView: PageListView = {
        let view = PageListView()
        view.backgroundColor = SColor.backgroundColor1
        view.delegate = self
        return view
    }()

    let stockColumnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = SColor.backgroundColor2
        return stackView
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
        view.addSubview(stockColumnStackView)
        pageListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        stockColumnStackView.snp.makeConstraints {
            $0.top.equalTo(pageListView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        setupSortColumnView()
    }

    func setupSortColumnView() {
        let types = StockListColumnType.allCases
        for type in types {
            let sortView = SortableView<StockListColumnType>()
            sortView.setColumnType(type)
            sortView.sortTypeDidSet.sink { [weak self] columnType, sortType in
                self?.sortTypeDidSet(column: columnType, sortType: sortType)
            }.store(in: &cancelBags)
            stockColumnStackView.addArrangedSubview(sortView)
        }
    }

    // TODO: - Implement logic
    func sortTypeDidSet(column _: StockListColumnType?, sortType _: SortType) {}
}

// MARK: - PageListViewDelegate

extension StockListViewController: PageListViewDelegate {
    func pageDidSelected(item _: any PageItemProtocol) {}
}
