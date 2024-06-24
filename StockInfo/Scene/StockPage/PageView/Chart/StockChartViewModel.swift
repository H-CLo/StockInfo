//
//  StockChartViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/24.
//

import Combine
import Foundation

protocol StockChartViewModelSpec {
    var chartModel: StockChartModel { get }
    func fetchStockChart()
    var chartDataDidGet: PassthroughSubject<StockChartModel, Never> { get }
}

final class StockChartViewModel: BaseViewModel {
    private let id: String
    var chartModel = StockChartModel(data: [])
    var chartDataDidGet: PassthroughSubject<StockChartModel, Never> = .init()

    init(id: String, appDependencies: AppDependencies) {
        self.id = id
        super.init(appDependencies: appDependencies)
    }
}

extension StockChartViewModel {
    func fetchStockChart() {
        apiManager.fetchStockChart(stockID: id) { [weak self] result in
            switch result {
            case let .success(model):
                self?.chartModel = model
                self?.chartDataDidGet.send(model)
            case .failure:
                break
            }
        }
    }
}
