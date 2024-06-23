//
//  StockListCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

final class StockListCoordinator: Coordinator {

    override func start() {
        let stockListViewController = StockListViewController(viewModel: StockListViewModel(appDependencies: appDependencies))
        stockListViewController.delegate = self
        navigationController.setViewControllers([stockListViewController], animated: false)
    }
}

extension StockListCoordinator: StockListViewControllerDelegate {
    func showStockPage(id: String) {
        let coordinator = StockPageCoordinator(navigationController: navigationController, appDependencies: appDependencies)
        coordinator.stockID = id
        coordinator.start()
    }
}
