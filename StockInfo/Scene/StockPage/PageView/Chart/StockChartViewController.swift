//
//  StockChartViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/24.
//

import Combine
import DGCharts
import UIKit

class StockChartViewController: BaseViewController<StockChartViewModel> {
    // MARK: - Property

    private var cancelBags = Set<AnyCancellable>()

    lazy var chartView: CandleStickChartView = {
        let charView = CandleStickChartView(frame: .zero)
        charView.backgroundColor = SColor.backgroundColor1
        return charView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.fetchStockChart()
    }
}

extension StockChartViewController {
    func setupUI() {
        view.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(206)
        }
    }
}

extension StockChartViewController {
    func bind() {
        viewModel.chartDataDidGet.sink { [weak self] result in
            self?.setupCharts(model: result)
        }.store(in: &cancelBags)
    }
}

extension StockChartViewController {
    func setupCharts(model: StockChartModel) {
        let yVals = (0 ..< model.data.count).map { i -> CandleChartDataEntry in
            let chartData = model.data[i]
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: chartData.high,
                                        shadowL: chartData.low,
                                        open: chartData.open,
                                        close: chartData.close)
        }

        let set = CandleChartDataSet(entries: yVals)
        set.axisDependency = .right
        set.setColor(.darkGray)
        set.drawIconsEnabled = false
        set.shadowColorSameAsCandle = true
        set.shadowWidth = 1
        set.decreasingColor = SColor.downColor
        set.decreasingFilled = true
        set.increasingColor = SColor.upColor
        set.increasingFilled = true
        set.drawValuesEnabled = false
        // 長按十字
        set.highlightEnabled = true
        set.highlightColor = SColor.yellowColor1
        set.highlightLineWidth = 1

        // 調整 x軸 Label
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .white
        let xValueFormatter = ChartAxisFormatter(data: model.data)
        chartView.xAxis.valueFormatter = xValueFormatter

        // 左側 Y軸 Label 隱藏
        chartView.leftAxis.drawLabelsEnabled = false
        // 調整右側Y軸 Label
        chartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.rightAxis.labelTextColor = .white
        // Disable double tapped
        chartView.doubleTapToZoomEnabled = false

        let data = CandleChartData(dataSet: set)
        chartView.data = data
    }
}

extension StockChartViewController {
    class ChartAxisFormatter: IndexAxisValueFormatter {
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
}
