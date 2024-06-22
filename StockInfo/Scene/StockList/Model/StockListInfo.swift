//
//  StockListInfo.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

struct StockListInfo {
    let baseInfo: StockBaseInfo
    let stock: WatchListStock
    let upDown: StockUpDown

    init(baseInfo: StockBaseInfo, stock: WatchListStock) {
        self.baseInfo = baseInfo
        self.stock = stock
        self.upDown = StockUpDown(diffPrice: stock.diff)
    }
}
