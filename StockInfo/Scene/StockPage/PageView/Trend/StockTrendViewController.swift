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
        setupLayout()
        setupUI()
        bind()
        setChartConfig()
        viewModel.start()
    }
}

// MARK: - StockPageViewProtocol

extension StockTrendViewController: StockPageViewProtocol {
    func setStockID(id: String) {
        viewModel.setStockID(id: id)
    }

    func reload() {
        viewModel.start()
    }
}

extension StockTrendViewController {
    func bind() {
        viewModel.isLoading.sink { isLoading in
            self.isLoading = isLoading
        }.store(in: &cancelBags)

        viewModel.trendDataDidGet.sink { [weak self] model in
            self?.setupCharts(model)
        }.store(in: &cancelBags)
    }
}

extension StockTrendViewController {
    func setupLayout() {
        view.backgroundColor = .black
    }

    func setupUI() {
        view.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Chart

extension StockTrendViewController {
    func setChartConfig() {
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
    }

    func setupCharts(_ model: StockTrendModel) {
        let dataEntries = model.trends.sorted(by: { $0.timeInterval < $1.timeInterval }).map { ChartDataEntry(x: $0.timeInterval, y: $0.price) }
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Line chart")

        // 美術設定
        dataSet.drawCirclesEnabled = false
        // 折線顏色
        dataSet.setColors(SColor.upColor)
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
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.valueFormatter = TrendXAxisValueFormatter(data: model.trends)

        chartView.rightAxis.drawLabelsEnabled = false
        chartView.leftAxis.labelPosition = .outsideChart
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.leftAxis.labelTextColor = .white
        let yAxisRenderer = TrendLeftAxisRenderer(viewPortHandler: chartView.leftYAxisRenderer.viewPortHandler,
                                                  axis: chartView.leftYAxisRenderer.axis,
                                                  transformer: chartView.leftYAxisRenderer.transformer)
        yAxisRenderer.refPrice = viewModel.watchListStock?.refPrice.doubleValue ?? 0
        chartView.leftYAxisRenderer = yAxisRenderer

        let lineChartRenderer = TrendLineChartRenderer(dataProvider: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
        chartView.renderer = lineChartRenderer

        // Set data
        let chartData = LineChartData(dataSets: [dataSet])
        chartView.data = chartData
    }
}

extension StockTrendViewController: ChartViewDelegate {}
