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

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        let cellName = String(describing: StockListTableViewCell.self)
        tableView.register(StockListTableViewCell.self, forCellReuseIdentifier: cellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = SColor.backgroundColor1
        return tableView
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
        view.addSubview(tableView)
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
        tableView.snp.makeConstraints {
            $0.top.equalTo(stockColumnStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
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

// MARK: - UITableViewDataSource

extension StockListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StockListTableViewCell.self), for: indexPath) as? StockListTableViewCell else { return UITableViewCell() }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StockListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Show stock page view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
