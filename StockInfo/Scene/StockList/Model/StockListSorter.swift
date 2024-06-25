//
//  StockListSorter.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

struct StockListSorter {
    let columnType: StockListColumnType
    let sortType: SortType
    let items: [StockListInfo]

    func sortItems() -> [StockListInfo] {
        switch columnType {
        case .name:
            if sortType == .up {
                return items.sorted(by: { $0.baseInfo.commodity_id.doubleValue < $1.baseInfo.commodity_id.doubleValue })
            } else if sortType == .down {
                return items.sorted(by: { $0.baseInfo.commodity_id.doubleValue > $1.baseInfo.commodity_id.doubleValue })
            }
        case .price:
            if sortType == .up {
                return items.sorted(by: { $0.stock.currentPrice.doubleValue < $1.stock.currentPrice.doubleValue })
            } else if sortType == .down {
                return items.sorted(by: { $0.stock.currentPrice.doubleValue > $1.stock.currentPrice.doubleValue })
            }
        case .upDown:
            if sortType == .up {
                return items.sorted(by: { removePercent($0.stock.diffRatio).doubleValue < removePercent($1.stock.diffRatio).doubleValue })
            } else if sortType == .down {
                return items.sorted(by: { removePercent($0.stock.diffRatio).doubleValue > removePercent($1.stock.diffRatio).doubleValue })
            }
        }

        return items
    }

    func removePercent(_ text: String) -> String {
        return text.replacingOccurrences(of: "%", with: "")
    }
}
