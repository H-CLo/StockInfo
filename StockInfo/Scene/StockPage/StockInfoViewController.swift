//
//  StockInfoViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Combine
import SnapKit
import UIKit

class StockInfoViewController: BaseViewController<StockInfoViewModel> {
    private var cancelBags = Set<AnyCancellable>()
    lazy var pageViewController = StockPageViewController()

    let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = SColor.backgroundColor
        return view
    }()

    let stockMarketLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = SColor.grayColor2
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 39)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    let upDownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    lazy var pageListView: PageListView = {
        let view = PageListView()
        view.backgroundColor = SColor.backgroundColor1
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.fetchStockBaseInfo()
    }
}

// MARK: - UI

extension StockInfoViewController {
    func setupUI() {
        view.addSubview(topContainerView)
        topContainerView.addSubview(stockMarketLabel)
        topContainerView.addSubview(timeLabel)
        topContainerView.addSubview(priceLabel)
        topContainerView.addSubview(upDownLabel)
        view.addSubview(pageListView)

        topContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(72)
        }

        stockMarketLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(16)
        }

        timeLabel.snp.makeConstraints {
            $0.top.equalTo(stockMarketLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(16)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(stockMarketLabel.snp.bottom).offset(6)
            $0.leading.equalTo(stockMarketLabel.snp.leading)
            $0.height.equalTo(38)
        }

        upDownLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.top)
            $0.leading.equalTo(priceLabel.snp.trailing).offset(5)
            $0.height.equalTo(38)
        }

        pageListView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        // Setup pageList
        setupPageListView(viewModel.stockPageTypes)

        // Setup PageViewController
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(pageListView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        pageViewController.stockPageViewDelegate = self
    }

    func setupPageListView(_ types: [StockPageType]) {
        var models = [PageItemModel]()
        for (index, type) in types.enumerated() {
            let model = PageItemModel(index: index, title: type.title)
            models.append(model)
        }
        pageListView.config(items: models)
    }
}

extension StockInfoViewController {
    func bind() {
        viewModel.isLoading.sink { [weak self] isLoading in
            self?.isLoading = isLoading
        }.store(in: &cancelBags)

        viewModel.watchListStockDidSet
            .compactMap { $0 }
            .sink { [weak self] model in
                self?.setupStockInformation(model: model)
            }.store(in: &cancelBags)
    }

    func setupStockInformation(model: WatchListStock) {
        let stockBaseInfo = viewModel.getStockInfo(byID: viewModel.stockID)
        stockMarketLabel.text = stockBaseInfo?.trading_market.title
        let upDown = StockUpDown(diffPrice: model.diff)
        priceLabel.text = model.currentPrice
        priceLabel.textColor = upDown.color
        upDownLabel.text = "\(upDown.triangleSymbol) \(model.diff)\n\(model.diffRatio)"
        upDownLabel.textColor = upDown.color

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd(EEEE) HH:mm"
        formatter.locale = Locale(identifier: "Asia/Taipei")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        timeLabel.text = formatter.string(from: Date())
    }
}

// MARK: - PageListViewDelegate

extension StockInfoViewController: PageListViewDelegate {
    func pageDidSelected(item: PageItemProtocol) {
        pageViewController.scrollTo(index: item.index)
    }

    func pageItemScrollToIndex(_ index: Int) {
        pageListView.scrollToIndex(index)
    }
}

extension StockInfoViewController: StockPageViewControllerDelegate {
    func pageViewController(_: UIPageViewController, didUpdatePageIndex pageIndex: Int) {
        pageListView.scrollToIndex(pageIndex)
    }
}
