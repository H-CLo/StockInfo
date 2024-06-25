//
//  TrendLeftAxisRenderer.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import DGCharts
import Foundation
import UIKit

class TrendLeftAxisRenderer: YAxisRenderer {
    var refPrice: Double = 0

    override func drawYLabels(context: CGContext, fixedPosition: CGFloat, positions: [CGPoint], offset: CGFloat, textAlign: TextAlignment) {
        let labelFont = axis.labelFont
        // let labelTextColor = axis.labelTextColor

        let from = axis.isDrawBottomYLabelEntryEnabled ? 0 : 1
        let to = axis.isDrawTopYLabelEntryEnabled ? axis.entryCount : (axis.entryCount - 1)

        let xOffset = axis.labelXOffset

        for i in from ..< to {
            let text = axis.getFormattedLabel(i)
            let value = Double(text) ?? 0
            let upDown = StockUpDown(diffPrice: (value - refPrice).description)
            let labelTextColor = upDown.color
            context.drawText(text,
                             at: CGPoint(x: fixedPosition + xOffset, y: positions[i].y + offset),
                             align: textAlign,
                             attributes: [.font: labelFont, .foregroundColor: labelTextColor])
        }
    }
}
