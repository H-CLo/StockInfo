//
//  StockPageType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

enum StockPageType: CaseIterable {
    case trend, chart, main, margin, discuss, revenue

    var title: String {
        switch self {
        case .trend:
            return LocalizeTool.string("即時")
        case .chart:
            return LocalizeTool.string("K線")
        case .main:
            return LocalizeTool.string("主力")
        case .margin:
            return LocalizeTool.string("資券")
        case .discuss:
            return LocalizeTool.string("討論")
        case .revenue:
            return LocalizeTool.string("營收")
        }
    }
}
