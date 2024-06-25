//
//  StockListViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Combine
import Foundation

protocol StockListViewModelSpec {
    var stockBaseInfos: Set<StockBaseInfo> { get }
    var watchLists: [WatchList] { get }
    var watchListIndex: Int { get }
    var watchListStocks: [String: WatchListStock] { get }
    var stockListInfos: [StockListInfo] { get }
    var sortColumnType: StockListColumnType? { get }
    var sortType: SortType { get }

    // func
    func changePageItem(_ item: PageItemProtocol)
    func sortItems(columnType: StockListColumnType, sortType: SortType)
    func fetchStockBaseInfo()
    func fetchWatchListAll()
    func fetchWatchListStocks(stockIDs: [String])
    func getSequenceCount() -> Int
    func getSequenceItem(index: Int) -> StockListInfo?

    // Binding
    var watchListsDidSet: PassthroughSubject<[WatchList], Never> { get }
    var watchListStocksDidSet: PassthroughSubject<Void, Never> { get }
}

final class StockListViewModel: BaseViewModel, StockListViewModelSpec {
    private(set) var stockBaseInfos: Set<StockBaseInfo> = []
    private(set) var watchLists: [WatchList] = []
    private(set) var watchListIndex: Int = 0
    private(set) var watchListStocks: [String: WatchListStock] = [:]
    private(set) var stockListInfos: [StockListInfo] = []
    private(set) var sortColumnType: StockListColumnType?
    private(set) var sortType: SortType = .none

    var watchListsDidSet: PassthroughSubject<[WatchList], Never> = .init()
    var watchListStocksDidSet: PassthroughSubject<Void, Never> = .init()
}

// MARK: - Spec

extension StockListViewModel {
    func changePageItem(_ item: PageItemProtocol) {
        // cancel polling
        guard let index = watchLists.firstIndex(where: { $0.order == item.index && $0.display_name == item.title }) else { return }
        watchListIndex = index
        fetchWatchListStocksByIndex()
    }

    func sortItems(columnType: StockListColumnType, sortType: SortType) {
        // update property
        sortColumnType = columnType
        self.sortType = sortType
        stockListInfos = StockListSorter(columnType: columnType, sortType: sortType, items: stockListInfos).sortItems()
    }
}

// MARK: - TableView

extension StockListViewModel {
    func getSequenceCount() -> Int {
        return stockListInfos.count
    }

    func getSequenceItem(index: Int) -> StockListInfo? {
        return stockListInfos[safe: index]
    }
}

// MARK: - Api

extension StockListViewModel {
    func fetchStockBaseInfo() {
        isLoading.send(true)

        apiManager.fetchStockBaseInfo { [weak self] result in
            switch result {
            case let .success(models):
                self?.stockBaseInfos = Set(models)
                self?.fetchWatchListAll()
            case .failure:
                break
            }
        }
    }

    func fetchWatchListAll() {
        apiManager.fetchWatchListAll { [weak self] result in
            switch result {
            case let .success(models):
                self?.watchLists = models
                self?.watchListsDidSet.send(models)
                // 預設是第0筆為顯示，抓第0筆的 stocks information
                self?.fetchWatchListStocksByIndex()
            case .failure:
                break
            }
        }
    }

    func fetchWatchListStocksByIndex() {
        isLoading.send(true)
        let index = watchListIndex
        guard let ids = watchLists[safe: index]?.stock_ids else { return }
        fetchWatchListStocks(stockIDs: ids)
        // Start polling
    }

    func fetchWatchListStocks(stockIDs: [String]) {
        apiManager.fetchWatchListStocks(stockIDs: stockIDs) { [weak self] result in
            switch result {
            case let .success(models):
                self?.watchListStocks = models
                self?.constructStockListInfos(models: models)
                self?.watchListStocksDidSet.send()
            case .failure:
                break
            }
            self?.isLoading.send(false)
        }
    }

    func constructStockListInfos(models: [String: WatchListStock]) {
        var infos = [StockListInfo]()
        for model in models {
            guard let baseInfo = stockBaseInfos.first(where: { $0.commodity_id == model.key }) else { continue }
            let info = StockListInfo(baseInfo: baseInfo, stock: model.value)
            infos.append(info)
        }
        stockListInfos = infos
    }
}
