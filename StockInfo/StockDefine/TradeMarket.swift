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

    var title: String {
        switch self {
        case .listedCompany:
            return LocalizeTool.string("上市")
        case .otc:
            return LocalizeTool.string("上櫃")
        case .emerging:
            return LocalizeTool.string("興櫃")
        }
    }
}
