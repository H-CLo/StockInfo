//
//  CustomChartRenderer.swift
//  StockInfo
//
//  Created by Lo on 2024/6/26.
//

import Foundation
import DGCharts
import UIKit

class CustomChartRenderer: CandleStickChartRenderer {

    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        super.drawHighlighted(context: context, indices: indices)
        
        debugPrint("Indices = \(indices)")


//        guard
//            let dataProvider = dataProvider,
//            let candleData = dataProvider.candleData
//            else { return }
//
//        context.saveGState()
//
//        for high in indices
//        {
//            guard
//                let set = candleData[high.dataSetIndex] as? CandleChartDataSetProtocol,
//                set.isHighlightEnabled
//                else { continue }
//
//            guard let e = set.entryForXValue(high.x, closestToY: high.y) as? CandleChartDataEntry else { continue }
//
//            if !isInBoundsX(entry: e, dataSet: set)
//            {
//                continue
//            }
//
//            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
//
//            context.setStrokeColor(set.highlightColor.cgColor)
//            context.setLineWidth(set.highlightLineWidth)
//
//            if set.highlightLineDashLengths != nil
//            {
//                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
//            }
//            else
//            {
//                context.setLineDash(phase: 0.0, lengths: [])
//            }
//
//            let lowValue = e.low * Double(animator.phaseY)
//            let highValue = e.high * Double(animator.phaseY)
//            let y = (lowValue + highValue) / 2.0
//
//            let pt = trans.pixelForValues(x: e.x, y: y)
//
//            high.setDraw(pt: pt)
//
//            // draw the lines
//            drawHighlightLines(context: context, point: pt, set: set)
//        }
//
//        context.restoreGState()
    }
}
