//
//  Double+.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

extension Double {

    func interceptDecimal(style: NumberFormatter.Style = .decimal,
                          minDigits: Int = 2,
                          maxDigits: Int = 2,
                          roundingMode: NumberFormatter.RoundingMode = .floor) -> String {
        let format = NumberFormatter.init()
        format.numberStyle = .decimal
        format.minimumFractionDigits = minDigits // 最少小數位
        format.maximumFractionDigits = maxDigits // 最多小數位
        format.formatterBehavior = .default
        format.roundingMode = roundingMode
        return format.string(from: NSNumber(floatLiteral: self)) ?? ""
    }
}
