//
//  StockTrendModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

struct StockTrendModel {
    let trends: [TrendModel]

    init(dict: [String: Double]) {
        trends = dict.map { TrendModel(timeStr: $0.key, price: $0.value) }
    }
}

extension StockTrendModel {
    struct TrendModel {
        let timeStr: String
        let timeInterval: Double
        let price: Double

        init(timeStr: String, price: Double) {
            self.timeStr = timeStr
            timeInterval = Double(timeStr) ?? 0
            self.price = price
        }
    }
}
