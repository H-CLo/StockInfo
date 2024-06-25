//
//  String+.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

extension String {

    var doubleValue: Double {
        return Double(self) ?? 0
    }

    func intervalToDate() -> Date? {
        guard let integer = Int(self) else { return nil }
        let timeInterval = TimeInterval(integer)
        return Date(timeIntervalSince1970: timeInterval)
    }
}
