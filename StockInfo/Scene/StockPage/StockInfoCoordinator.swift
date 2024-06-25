//
//  StockInfoCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation
import UIKit

final class StockInfoCoordinator: Coordinator {
    var index: Int = 0
    var infos = [StockBaseInfo]()
    var stockID: String {
        return infos[safe: index]?.commodity_id ?? ""
    }

    private(set) var pageViewControllers = [UIViewController]()

    override func start() {
        let types = StockPageType.allCases
        let viewModel = StockInfoViewModel(index: index, infos: infos, stockPageTypes: types, appDependencies: appDependencies)
        let viewController = StockInfoViewController(viewModel: viewModel)
        viewController.pageViewController = makeStockPage(types)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension StockInfoCoordinator {
    func makeStockPage(_: [StockPageType]) -> StockPageViewController {
        let stockPageViewContorller = StockPageViewController()
        let viewControllers = makePageViewControllers(StockPageType.allCases)
        pageViewControllers = viewControllers
        stockPageViewContorller.setupViewControllers(viewControllers)
        stockPageViewContorller.start()
        return stockPageViewContorller
    }

    func makePageViewControllers(_ types: [StockPageType]) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        types.forEach {
            switch $0 {
            case .trend:
                let viewModel = StockTrendViewModel(id: stockID, appDependencies: appDependencies)
                let trendViewController = StockTrendViewController(viewModel: viewModel)
                viewControllers.append(trendViewController)
            case .chart:
                let viewModel = StockChartViewModel(id: stockID, appDependencies: appDependencies)
                let chartViewController = StockChartViewController(viewModel: viewModel)
                viewControllers.append(chartViewController)
            case .main:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                viewControllers.append(vc)
            case .margin:
                let vc = UIViewController()
                vc.view.backgroundColor = .green
                viewControllers.append(vc)
            case .discuss:
                let vc = UIViewController()
                vc.view.backgroundColor = .purple
                viewControllers.append(vc)
            case .revenue:
                let vc = UIViewController()
                vc.view.backgroundColor = .red
                viewControllers.append(vc)
            }
        }
        return viewControllers
    }
}
