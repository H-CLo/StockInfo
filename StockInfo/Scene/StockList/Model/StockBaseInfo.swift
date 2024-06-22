//
//  StockBaseInfoResModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

struct StockBaseInfo: Codable {
    let commodity_id: String
    let commodity_name: String
    let trading_market: TradeMarket
}

enum TradeMarket: Int, Codable {
    /// 上市
    case listedCompany = 1
    /// 上櫃
    case otc = 2
    /// 興櫃
    case emerging = 3
}
