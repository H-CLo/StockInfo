//
//  StockInfoViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Combine
import Foundation

protocol StockInfoViewModelSpec {
    // Input
    var index: Int { get set }
    var infos: [StockBaseInfo] { get }
    var stockPageTypes: [StockPageType] { get }
    var watchListStock: WatchListStock { get }

    // Output
    func getStockInfo(byID: String) -> StockBaseInfo

    // Binding
    var watchListStockDidSet: PassthroughSubject<WatchListStock, Never> { get }
}

final class StockInfoViewModel: BaseViewModel {
    var index: Int
    let infos: [StockBaseInfo]
    var stockID: String { infos[safe: index]?.commodity_id ?? "" }
    let stockPageTypes: [StockPageType]
    private(set) var watchListStock: WatchListStock?

    var watchListStockDidSet: PassthroughSubject<WatchListStock?, Never> = .init()

    init(index: Int, infos: [StockBaseInfo], stockPageTypes: [StockPageType], appDependencies: AppDependencies) {
        self.index = index
        self.infos = infos
        self.stockPageTypes = stockPageTypes
        super.init(appDependencies: appDependencies)
    }

    func start() {
        fetchWatchListStocks(stockIDs: [stockID])
    }
}

extension StockInfoViewModel {
    func fetchWatchListStocks(stockIDs: [String]) {
        isLoading.send(true)
        apiManager.fetchWatchListStocks(stockIDs: stockIDs) { [weak self] result in
            switch result {
            case let .success(models):
                self?.watchListStock = models.first?.value
                self?.watchListStockDidSet.send(models.first?.value)
            case .failure:
                break
            }
            self?.isLoading.send(false)
        }
    }
}
