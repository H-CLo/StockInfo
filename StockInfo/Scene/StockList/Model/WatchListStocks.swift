//
//  WatchListStocks.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

struct WatchListStocksReqModel: Codable {
    let stock_ids: [String]
}

struct WatchListStock: Codable {
    let currentPrice: String
    let diff: String
    let diffRatio: String
    let refPrice: String
}
