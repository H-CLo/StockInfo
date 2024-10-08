//
//  Color.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import UIKit

/// Manage Colors
class SColor {
    static func color(_ style: String, alpha: CGFloat = 1) -> UIColor {
        let r, g, b: CGFloat
        let hex = style
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000FF) / 255
                return UIColor(red: r, green: g, blue: b, alpha: alpha)
            }
        }
        /// 若為非16進制Style則回傳無顏色Color
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
}

extension SColor {
    static let textColor1 = SColor.color("#ACA193")
    static let textColor2 = SColor.color("#000000")
    static let textColor3 = SColor.color("#463D46")
    static let yellowColor = SColor.color("#FFCB3C")
    static let yellowColor1 = SColor.color("#FFB13B")
    static let yellowColor2 = SColor.color("#FFF961")
    static let disableColor = SColor.color("#2B202B")
    static let grayColor1 = SColor.color("#ABABAB")
    static let grayColor2 = SColor.color("#7A7A7A")
    static let grayColor3 = SColor.color("#595959")
    static let backgroundColor = SColor.color("#212121")
    static let backgroundColor1 = SColor.color("#141414")
    static let backgroundColor2 = SColor.color("#2F2F2F")
    static let upColor = SColor.color("#F84444")
    static let downColor = SColor.color("#47AB75")
    static let purpleColor = SColor.color("#7B61FF")
    static let blueColor = SColor.color("#00B0E9")
    static let pinkColor = SColor.color("#F55991")
    static let pinkColor2 = SColor.color("#FF8282")
    static let greenColor = SColor.color("#4BEEBB")
}
