//
//  StockChartLineType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

enum StockChartLineType: CaseIterable {
    case open, high, low, close
    case upDown
    case ma5, ma10, ma20, ma60, ma120, ma240
    case bbandsTop, bbandsMid, bbandsBottom

    var title: String {
        switch self {
        case .open:
            return LocalizeTool.string("開")
        case .high:
            return LocalizeTool.string("高")
        case .low:
            return LocalizeTool.string("低")
        case .close:
            return LocalizeTool.string("收")
        case .upDown:
            return ""
        case .ma5:
            return LocalizeTool.string("5MA")
        case .ma10:
            return LocalizeTool.string("10MA")
        case .ma20:
            return LocalizeTool.string("20MA")
        case .ma60:
            return LocalizeTool.string("60MA")
        case .ma120:
            return LocalizeTool.string("120MA")
        case .ma240:
            return LocalizeTool.string("240MA")
        case .bbandsTop:
            return LocalizeTool.string("布林頂")
        case .bbandsMid:
            return LocalizeTool.string("布林中")
        case .bbandsBottom:
            return LocalizeTool.string("布林底")
        }
    }

    // 均線日數
    var days: Int {
        switch self {
        case .ma5:
            return 5
        case .ma10:
            return 10
        case .ma20:
            return 20
        case .ma60:
            return 60
        case .ma120:
            return 120
        case .ma240:
            return 240
        default:
            return 0
        }
    }
}
