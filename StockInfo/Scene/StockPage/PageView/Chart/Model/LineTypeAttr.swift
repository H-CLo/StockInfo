//
//  LineTypeAttr.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation
import UIKit

class StockLineTypeAttrBuilder {
    let type: StockChartLineType
    let value: String
    let valueColor: UIColor
    let upDown: Bool
    let upDownArrow: Bool

    init(type: StockChartLineType, value: String, valueColor: UIColor = .white, upDown: Bool = false, upDownArrow: Bool = false) {
        self.type = type
        self.value = value
        self.valueColor = valueColor
        self.upDown = upDown
        self.upDownArrow = upDownArrow
    }

    func buildAttr() -> NSMutableAttributedString {
        let attr = NSMutableAttributedString()

        let title = NSMutableAttributedString(string: type.title, 
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), .foregroundColor: getTitleColor()])
        attr.append(title)
        attr.append(NSAttributedString(string: " "))
        let value = NSMutableAttributedString(string: value,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), .foregroundColor: valueColor])
        attr.append(value)
        if upDownArrow {
            let upDownType = upDown ? StockUpDown.up : StockUpDown.down
            let arrow = NSMutableAttributedString(string: upDown ? "↑" : "↓",
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), .foregroundColor: upDownType.color])
            attr.append(arrow)
        }
        // Append space
        attr.append(NSAttributedString(string: " "))
        return attr
    }

    private func getTitleColor() -> UIColor {
        switch type {
        case .open, .high, .low, .close:
            return .white
        case .upDown:
            return .clear
        case .ma5:
            return SColor.yellowColor1
        case .ma10:
            return SColor.yellowColor2
        case .ma20:
            return SColor.purpleColor
        case .ma60:
            return SColor.blueColor
        case .ma120:
            return SColor.pinkColor
        case .ma240:
            return SColor.greenColor
        case .bbandsTop, .bbandsMid, .bbandsBottom:
            return SColor.pinkColor2
        }
    }
}
