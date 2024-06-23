//
//  StockPageViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

protocol StockPageViewModelSpec {
    // Input
    var stockID: String { get }
}

final class StockPageViewModel: BaseViewModel {
    let stockID: String

    init(stockID: String, appDependencies: AppDependencies) {
        self.stockID = stockID
        super.init(appDependencies: appDependencies)
    }
}
