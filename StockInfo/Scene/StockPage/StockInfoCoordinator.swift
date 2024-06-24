//
//  StockInfoCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation
import UIKit

final class StockInfoCoordinator: Coordinator {
    var stockID: String = ""
    private(set) var pageViewControllers = [UIViewController]()

    override func start() {
        let types = StockPageType.allCases
        let viewModel = StockInfoViewModel(stockID: stockID, stockPageTypes: types, appDependencies: appDependencies)
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
                viewControllers.append(UIViewController())
            case .main, .margin, .discuss, .revenue:
                viewControllers.append(UIViewController())
            }
        }
        return viewControllers
    }
}
