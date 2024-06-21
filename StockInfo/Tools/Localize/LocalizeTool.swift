//
//  LocalizeTool.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

class LocalizeTool {
    static func string(_ key: String, comment: String = "") -> String {
        NSLocalizedString(key, comment: comment)
    }
}
