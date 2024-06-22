//
//  WatchListAllResModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

struct WatchList: Codable {
    let created_at: Double
    let display_name: String
    let id: Int
    let order: Int
    let stock_ids: [String]
}
