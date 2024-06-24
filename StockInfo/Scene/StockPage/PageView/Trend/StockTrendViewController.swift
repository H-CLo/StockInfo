//
//  StockTrendViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Combine
import DGCharts
import SnapKit
import UIKit

final class StockTrendViewController: BaseViewController<StockTrendViewModel> {
    // MARK: - Property

    private var cancelBags = Set<AnyCancellable>()

    lazy var chartView: LineChartView = {
        let charView = LineChartView(frame: .zero)
        charView.delegate = self
        return charView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        setChartConfig()
        viewModel.fetchStockTrend()

        let entries = makeEntries()
        setupCharts(entries)
    }
}

extension StockTrendViewController {
    func bind() {
        viewModel.trendDataDidGet
            .map { model in
                model.trends.sorted(by: { $0.timeInterval < $1.timeInterval }).map { ChartDataEntry(x: $0.timeInterval, y: $0.price) }
            }.sink { [weak self] _ in
                // self?.setupCharts(entries)
            }.store(in: &cancelBags)
    }
}

extension StockTrendViewController {
    func setupUI() {
        view.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension StockTrendViewController: ChartViewDelegate {}

// MARK: - Chart

extension StockTrendViewController {
    func setChartConfig() {
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.backgroundColor = SColor.backgroundColor1
    }

    func makeEntries() -> [ChartDataEntry] {
        var dataEntries = [ChartDataEntry]()
        var dataEntries1 = [ChartDataEntry]()
        for i in 0 ..< 20 {
            let y = arc4random() % 50
            let entry = ChartDataEntry(x: Double(i + 1), y: Double(y))
            debugPrint("Y value = \(y)")
            dataEntries.append(entry)
        }
        return dataEntries
    }

    func setupCharts(_ dataEntries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Line chart")

        // 美術設定
        dataSet.drawCirclesEnabled = false
        // 折線顏色
        dataSet.setColors(.clear)
        // 長按十字
        dataSet.highlightEnabled = true
        dataSet.highlightColor = SColor.yellowColor1
        dataSet.highlightLineWidth = 1
        // 填滿顏色
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = SColor.color("#f84444", alpha: 0.3)
        // 不顯示點的資料
        dataSet.drawValuesEnabled = false

        chartView.xAxis.drawLabelsEnabled = true
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.leftAxis.labelPosition = .outsideChart
        chartView.leftAxis.labelTextColor = .white

        // ChartLimitLine(limit: <#T##Double#>, label: <#T##String#>)
        // chartView.leftAxis.addLimitLine(<#T##line: ChartLimitLine##ChartLimitLine#>)

        let chartData = LineChartData(dataSets: [dataSet])
        chartView.data = chartData
        // chartView.renderer = CustomLineChartRenderer(dataProvider: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    }

    func setupXAxis(min _: Double, max _: Double) {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255 / 255, green: 192 / 255, blue: 56 / 255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
    }

    func setupYAxis() {
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 12)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 900
        leftAxis.axisMaximum = 1000
        leftAxis.labelTextColor = .white
    }
}

class CustomLineChartRenderer: LineChartRenderer {
    override func drawLinear(context: CGContext, dataSet: LineChartDataSetProtocol) {
        guard let dataProvider = dataProvider else { return }

        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)

        // var entries = dataSet.en

        if dataSet.entryCount < 2 {
            return
        }

        context.saveGState()

        context.setLineWidth(dataSet.lineWidth)
        context.setLineCap(.butt)

        let valueToPixelMatrix = trans.valueToPixelMatrix

        for i in 0 ..< dataSet.entryCount - 1 {
            guard let entry = dataSet.entryForIndex(i) else { continue }
            guard let nextEntry = dataSet.entryForIndex(i + 1) else { continue }

            var startPoint = CGPoint(x: entry.x, y: entry.y).applying(valueToPixelMatrix)
            var endPoint = CGPoint(x: nextEntry.x, y: nextEntry.y).applying(valueToPixelMatrix)

            // Determine the color based on y-value
            let color: UIColor
            if entry.y > 20 {
                color = .red
            } else {
                color = .blue
            }

            context.setStrokeColor(color.cgColor)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
        }

        context.restoreGState()
    }
}
