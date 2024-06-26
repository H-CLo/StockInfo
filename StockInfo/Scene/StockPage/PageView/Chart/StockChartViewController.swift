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

    let topContainer: UIView = {
        let view = UIView()
        return view
    }()

    let dateTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.layer.cornerRadius = 6
        stackView.clipsToBounds = true
        stackView.layer.borderColor = SColor.grayColor3.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()

    private(set) var dateTypeButtons: [UIButton] = []

    let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "setting"), for: .normal)
        button.layer.cornerRadius = 5.25
        button.layer.borderColor = SColor.grayColor3.cgColor
        button.layer.borderWidth = 0.88
        return button
    }()

    let lineTypeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    lazy var chartView: CustomCandleStickChartView = {
        let charView = CustomCandleStickChartView(frame: .zero)
        charView.delegate = self
        return charView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        bind()
        setupChartConfig()
        viewModel.start()
    }
}

// MARK: - StockPageViewProtocol

extension StockChartViewController: StockPageViewProtocol {
    func setStockID(id: String) {
        viewModel.setStockID(id: id)
    }

    func reload() {
        viewModel.start()
    }
}

extension StockChartViewController {
    func bind() {
        viewModel.isLoading.sink { isLoading in
            self.isLoading = isLoading
        }.store(in: &cancelBags)

        viewModel.chartDataDidGet.sink { [weak self] result in
            self?.setupCharts(model: result)
            self?.displayLineTypeLabel(index: result.data.count - 1)
        }.store(in: &cancelBags)
    }
}

extension StockChartViewController {
    func setupLayout() {
        view.backgroundColor = .black
    }

    func setupUI() {
        view.addSubview(topContainer)
        topContainer.addSubview(dateTypeStackView)
        topContainer.addSubview(settingButton)
        view.addSubview(lineTypeLabel)
        view.addSubview(chartView)
        topContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        dateTypeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(28)
        }
        setupDateTypeButtons()
        dateTypeButtons.first?.isSelected = true
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        lineTypeLabel.snp.makeConstraints {
            $0.top.equalTo(topContainer.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        chartView.snp.makeConstraints {
            $0.top.equalTo(lineTypeLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(206)
        }
    }

    func setupDateTypeButtons() {
        let types: [StockChartDateType] = [.day, .week, .month, .minute(value: 1), .recovery(value: .day)]
        let buttons = types.map {
            let button = AdaptableSizeButton()
            button.extendWidth = 15
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.setTitle($0.buttonTitle, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(SColor.grayColor1, for: .normal)
            button.setBackgroundColor(color: .clear, forState: .normal)
            button.setBackgroundColor(color: SColor.grayColor3, forState: .selected)
            button.addTarget(self, action: #selector(dateTypeButtonTapped), for: .touchUpInside)
            button.layer.cornerRadius = 4
            return button
        }

        buttons.forEach { dateTypeStackView.addArrangedSubview($0) }
        dateTypeButtons = buttons
    }

    @objc
    func dateTypeButtonTapped(_ button: UIButton) {
        dateTypeButtons.forEach { $0.isSelected = false }
        button.isSelected = true
    }
}

extension StockChartViewController {
    func setupChartConfig() {
        // 調整 x軸 Label
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .white
        // 左側 Y軸 Label 隱藏
        chartView.leftAxis.drawLabelsEnabled = false
        // 調整右側Y軸 Label
        chartView.rightAxis.labelFont = UIFont.systemFont(ofSize: 12)
        chartView.rightAxis.labelTextColor = .white
        // Disable gestures
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = false
    }

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
        set.setColor(.lightGray)
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

        // highlight 資料顯示
        chartView.chartDatas = model.data
        // x軸 資料顯示
        let xValueFormatter = CustomChartAxisFormatter(data: model.data)
        chartView.xAxis.valueFormatter = xValueFormatter

        // TODO: Custom renderer
        let customChartRenderer = CustomChartRenderer(dataProvider: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
        chartView.renderer = customChartRenderer

        let data = CandleChartData(dataSet: set)
        chartView.data = data
    }
}

// MARK: - ChartViewDeletage

extension StockChartViewController: ChartViewDelegate {
    func chartValueSelected(_: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        displayLineTypeLabel(index: Int(entry.x))
    }

    func displayLineTypeLabel(index: Int) {
        guard let chartData = viewModel.chartModel.data[safe: index] else { return }
        let attr = NSMutableAttributedString()

        // 開高低收
        let open = StockLineTypeAttrBuilder(type: .open, value: chartData.open.interceptDecimal(), valueColor: SColor.upColor).buildAttr()
        attr.append(open)
        let high = StockLineTypeAttrBuilder(type: .high, value: chartData.high.interceptDecimal(), valueColor: SColor.upColor).buildAttr()
        attr.append(high)
        let low = StockLineTypeAttrBuilder(type: .low, value: chartData.low.interceptDecimal(), valueColor: SColor.downColor).buildAttr()
        attr.append(low)
        let close = StockLineTypeAttrBuilder(type: .close, value: chartData.close.interceptDecimal(), valueColor: SColor.downColor).buildAttr()
        attr.append(close)

        // 漲跌
        // mock data
        let upDown = StockLineTypeAttrBuilder(type: .upDown, value: "▲ 1.0(10.00%)", valueColor: SColor.upColor).buildAttr()
        attr.append(upDown)
        // 進行換行
        attr.append(NSAttributedString(string: "\n"))

        // 均線
        let avgTypes: [StockChartLineType] = [.ma5, .ma10, .ma20, .ma60, .ma120, .ma240]
        avgTypes.forEach {
            let avgAttr = makeAvgAttr($0, index: index)
            attr.append(avgAttr)
        }

        // 布林通道 塞假資料
        let bbUp = StockLineTypeAttrBuilder(type: .bbandsTop, value: "19.29").buildAttr()
        attr.append(bbUp)
        let bbMid = StockLineTypeAttrBuilder(type: .bbandsMid, value: "19.29").buildAttr()
        attr.append(bbMid)
        let bbBottom = StockLineTypeAttrBuilder(type: .bbandsBottom, value: "19.29").buildAttr()
        attr.append(bbBottom)

        lineTypeLabel.attributedText = attr
    }

    func makeAvgAttr(_ type: StockChartLineType, index: Int) -> NSMutableAttributedString {
        let maAvg = viewModel.calculateAverage(type: type, index: index)
        let ma = StockLineTypeAttrBuilder(type: type, value: maAvg.0, upDown: maAvg.1, upDownArrow: true).buildAttr()
        return ma
    }
}
