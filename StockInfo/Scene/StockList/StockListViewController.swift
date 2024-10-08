//
//  StockListViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Combine
import SnapKit
import UIKit

protocol StockListViewControllerDelegate: AnyObject {
    func showStockInfo(index: Int, infos: [StockBaseInfo])
}

class StockListViewController: BaseViewController<StockListViewModel> {
    // MARK: - Property

    var cancelBags = Set<AnyCancellable>()
    weak var delegate: StockListViewControllerDelegate?

    // MARK: UI Component

    lazy var pageListView: PageListView = {
        let view = PageListView()
        view.backgroundColor = SColor.backgroundColor1
        view.delegate = self
        return view
    }()

    private(set) var sortViews: [SortableView<StockListColumnType>] = []
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
        tableView.backgroundColor = .black
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancelPolling()
    }
}

// MARK: - Bind

extension StockListViewController {
    func bind() {
        // ViewModel
        viewModel.isLoading.sink { isLoading in
            self.isLoading = isLoading
        }.store(in: &cancelBags)

        viewModel.watchListsDidSet.sink { [weak self] models in
            let items = models.map { PageItemModel(index: $0.order, title: $0.display_name) }
            self?.pageListView.config(items: items)
        }.store(in: &cancelBags)

        viewModel.watchListStocksDidSet.sink { [weak self] in
            self?.tableView.reloadData()
        }.store(in: &cancelBags)
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
            sortViews.append(sortView)
            stockColumnStackView.addArrangedSubview(sortView)
        }
    }

    func sortTypeDidSet(column: StockListColumnType?, sortType: SortType) {
        guard let column = column else { return }
        // 更新畫面
        sortViews
            .filter { $0.getColumnType() != column }
            .forEach { $0.resetSortType() }
        // 邏輯
        viewModel.sortItems(columnType: column, sortType: sortType)
        tableView.reloadData()
    }
}

// MARK: - PageListViewDelegate

extension StockListViewController: PageListViewDelegate {
    func pageDidSelected(item: PageItemProtocol) {
        sortViews.forEach { $0.resetSortType() }
        viewModel.changePageItem(item)
    }
}

// MARK: - UITableViewDataSource

extension StockListViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.getSequenceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StockListTableViewCell.self), for: indexPath) as? StockListTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let info = viewModel.getSequenceItem(index: indexPath.row) {
            cell.configCell(info: info)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StockListViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let info = viewModel.getSequenceItem(index: indexPath.row) else { return }
        delegate?.showStockInfo(index: indexPath.row, infos: viewModel.getWatchListStockBaseInfos())
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 76
    }
}
