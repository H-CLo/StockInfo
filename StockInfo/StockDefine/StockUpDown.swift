//
//  StockUpDown.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation
import UIKit

enum StockUpDown {
    case up, upLimit, down, downLimit, flat

    init(diffPrice: String) {
        let value = NSDecimalNumber(string: diffPrice)
        if value.doubleValue > 0 {
            self = .up
        } else if value.doubleValue == 0 {
            self = .flat
        } else {
            self = .down
        }
    }

    var color: UIColor {
        switch self {
        case .up, .upLimit:
            return SColor.upColor
        case .down, .downLimit:
            return SColor.downColor
        case .flat:
            return .white
        }
    }

    var triangleSymbol: String {
        switch self {
        case .up, .upLimit:
            return "▲"
        case .down, .downLimit:
            return "▼"
        case .flat:
            return ""
        }
    }
}
