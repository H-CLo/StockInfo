//
//  StockListColumnType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

enum StockListColumnType: Int, CaseIterable, SortableColumnProtocol {
    case name, price, upDown

    var id: Int {
        return rawValue
    }

    var title: String {
        switch self {
        case .name:
            return LocalizeTool.string("股票名稱")
        case .price:
            return LocalizeTool.string("股價")
        case .upDown:
            return LocalizeTool.string("漲跌幅")
        }
    }
}
