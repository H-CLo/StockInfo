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
    private(set) var id: String
    var chartModel = StockChartModel(data: [])
    var chartDataDidGet: PassthroughSubject<StockChartModel, Never> = .init()

    init(id: String, appDependencies: AppDependencies) {
        self.id = id
        super.init(appDependencies: appDependencies)
    }

    func start() {
        fetchStockChart()
    }

    func setStockID(id: String) {
        self.id = id
    }
}

extension StockChartViewModel {
    /// 計算均價與取得漲跌
    func calculateAverage(type: StockChartLineType, index: Int) -> (String, Bool) {
        let days = type.days

        var startIndex = index - days + 1
        var totalCount: Double = 0
        var totalValue: Double = 0
        while startIndex <= index {
            if startIndex >= 0 {
                totalCount += 1
                totalValue += chartModel.data[startIndex].close
            }
            startIndex += 1
        }

        let avg = totalValue / totalCount
        let avgStr = avg.interceptDecimal()
        let upDown = chartModel.data[index].close >= avg
        return (avgStr, upDown)
    }
}

extension StockChartViewModel {
    func fetchStockChart() {
        isLoading.send(true)
        apiManager.fetchStockChart(stockID: id) { [weak self] result in
            switch result {
            case let .success(model):
                self?.chartModel = model
                self?.chartDataDidGet.send(model)
            case .failure:
                break
            }
            self?.isLoading.send(false)
        }
    }
}
