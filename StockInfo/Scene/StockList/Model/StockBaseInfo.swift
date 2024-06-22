//
//  StockBaseInfoResModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

struct StockBaseInfo: Codable, Hashable {
    let commodity_id: String
    let commodity_name: String
    let trading_market: TradeMarket
}
