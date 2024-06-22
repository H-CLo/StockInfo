//
//  TradeMarketType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

enum TradeMarket: Int, Codable {
    /// 上市
    case listedCompany = 1
    /// 上櫃
    case otc = 2
    /// 興櫃
    case emerging = 3
}
