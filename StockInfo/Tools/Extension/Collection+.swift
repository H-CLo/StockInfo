//
//  Collection+.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
