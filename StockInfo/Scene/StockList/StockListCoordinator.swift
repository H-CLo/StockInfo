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
        stockListViewController.title = LocalizeTool.string("自選股")
        navigationController.setViewControllers([stockListViewController], animated: false)
    }
}

extension StockListCoordinator: StockListViewControllerDelegate {
    func showStockInfo(index: Int, infos: [StockBaseInfo]) {
        let coordinator = StockInfoCoordinator(navigationController: navigationController, appDependencies: appDependencies)
        coordinator.index = index
        coordinator.infos = infos
        coordinator.start()
    }
}
