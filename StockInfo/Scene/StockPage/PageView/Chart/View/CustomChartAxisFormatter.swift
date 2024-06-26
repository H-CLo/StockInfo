//
//  CustomChartAxisFormatter.swift
//  StockInfo
//
//  Created by Lo on 2024/6/26.
//

import Foundation
import DGCharts

class CustomChartAxisFormatter: IndexAxisValueFormatter {
    var chartDatas: [StockChartModel.ChartData] = []

    private lazy var dateFormatterGet: DateFormatter = {
        // set up date formatter using locale
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        // set up date formatter using locale
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter
    }()

    convenience init(data: [StockChartModel.ChartData]) {
        self.init()
        chartDatas = data
    }

    override func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        let index = Int(value)
        guard index < chartDatas.count,
              let date = dateFormatterGet.date(from: chartDatas[index].date) else { return "" }
        return dateFormatter.string(from: date)
    }
}
