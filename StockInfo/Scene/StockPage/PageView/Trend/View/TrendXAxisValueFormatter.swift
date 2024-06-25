//
//  TrendXAxisValueFormatter.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import DGCharts
import Foundation

class TrendXAxisValueFormatter: IndexAxisValueFormatter {
    var trends: [StockTrendModel.TrendModel] = []

    private lazy var dateFormatter: DateFormatter = {
        // set up date formatter using locale
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    convenience init(data: [StockTrendModel.TrendModel]) {
        self.init()
        trends = data
    }

    override func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}
