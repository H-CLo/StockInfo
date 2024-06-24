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
    var stockID: String { get }
    var stockPageTypes: [StockPageType] { get }
    var stockBaseInfos: Set<StockBaseInfo> { get }
    var watchListStock: WatchListStock { get }

    // Output
    func getStockInfo(byID: String) -> StockBaseInfo

    // Binding
    var watchListStockDidSet: PassthroughSubject<WatchListStock, Never> { get }
}

final class StockInfoViewModel: BaseViewModel {
    let stockID: String
    let stockPageTypes: [StockPageType]
    private(set) var stockBaseInfos: Set<StockBaseInfo> = []
    private(set) var watchListStock: WatchListStock?

    var watchListStockDidSet: PassthroughSubject<WatchListStock?, Never> = .init()

    init(stockID: String, stockPageTypes: [StockPageType], appDependencies: AppDependencies) {
        self.stockID = stockID
        self.stockPageTypes = stockPageTypes
        super.init(appDependencies: appDependencies)
    }

    func getStockInfo(byID: String) -> StockBaseInfo? {
        return stockBaseInfos.first(where: { $0.commodity_id == byID })
    }
}

extension StockInfoViewModel {
    func fetchStockBaseInfo() {
        isLoading.send(true)

        apiManager.fetchStockBaseInfo { [weak self] result in
            switch result {
            case let .success(models):
                self?.stockBaseInfos = Set(models)
                self?.fetchWatchListStocks(stockIDs: [self?.stockID ?? ""])
            case .failure:
                self?.isLoading.send(false)
            }
        }
    }

    func fetchWatchListStocks(stockIDs: [String]) {
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
