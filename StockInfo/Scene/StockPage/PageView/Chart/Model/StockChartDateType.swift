//
//  StockChartDateType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

enum StockChartDateType {
    case day, week, month
    case minute(value: Int)
    case recovery(value: StockChartRecoveryDateType)

    var buttonTitle: String {
        switch self {
        case .day:
            return LocalizeTool.string("日")
        case .week:
            return LocalizeTool.string("週")
        case .month:
            return LocalizeTool.string("月")
        case .minute(let value):
            return LocalizeTool.string("\(value)分 ▼")
        case .recovery(let value):
            return LocalizeTool.string("還原\(value.title) ▼")
        }
    }
}

enum StockChartRecoveryDateType {
    case day, week, month

    var title: String {
        switch self {
        case .day:
            return LocalizeTool.string("日")
        case .week:
            return LocalizeTool.string("週")
        case .month:
            return LocalizeTool.string("月")
        }
    }
}
