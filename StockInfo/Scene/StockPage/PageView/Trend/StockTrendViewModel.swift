//
//  StockTrendViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Combine
import Foundation

protocol StockTrendViewModelSpec {
    var trendModel: StockTrendModel { get }
    func fetchStockTrend()
    var trendDataDidGet: PassthroughSubject<StockTrendModel, Never> { get }
}

class StockTrendViewModel: BaseViewModel, StockTrendViewModelSpec {
    private(set) var id: String
    var watchListStock: WatchListStock?
    var trendModel = StockTrendModel(dict: [:])
    var trendDataDidGet: PassthroughSubject<StockTrendModel, Never> = .init()

    init(id: String, appDependencies: AppDependencies) {
        self.id = id
        super.init(appDependencies: appDependencies)
    }

    func start() {
        fetchWatchListStocks()
    }

    func setStockID(id: String) {
        self.id = id
    }
}

extension StockTrendViewModel {
    func fetchWatchListStocks() {
        isLoading.send(true)
        apiManager.fetchWatchListStocks(stockIDs: [id]) { [weak self] result in
            switch result {
            case let .success(models):
                self?.watchListStock = models.first?.value
                self?.fetchStockTrend()
            case .failure:
                break
            }
            self?.isLoading.send(false)
        }
    }

    func fetchStockTrend() {
        isLoading.send(true)
        apiManager.fetchStockTrend(stockID: id) { [weak self] result in
            switch result {
            case let .success(models):
                let model = StockTrendModel(dict: models)
                self?.trendModel = model
                self?.trendDataDidGet.send(model)
            case .failure:
                break
            }
            self?.isLoading.send(false)
        }
    }
}
