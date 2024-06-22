//
//  StockListCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

class StockListCoordinator: Coordinator {
    
    override func start() {
        let stockListViewController = StockListViewController(viewModel: StockListViewModel(appDependencies: appDependencies))
        navigationController.setViewControllers([stockListViewController], animated: false)
    }
}
