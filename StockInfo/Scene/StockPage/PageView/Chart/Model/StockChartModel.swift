//
//  StockChartModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/24.
//

import Foundation

struct StockChartModel: Codable {
    let data: [ChartData]
}

extension StockChartModel {
    struct ChartData: Codable {
        let date: String
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
    }
}
