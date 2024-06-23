//
//  StockPageCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

final class StockPageCoordinator: Coordinator {

    var stockID: String = ""

    override func start() {
        let viewModel = StockPageViewModel(stockID: stockID, appDependencies: appDependencies)
        let viewController = StockPageViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
