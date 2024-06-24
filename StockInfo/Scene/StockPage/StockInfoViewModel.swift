//
//  StockInfoViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import Foundation

protocol StockInfoViewModelSpec {
    // Input
    var stockID: String { get }
    var stockPageTypes: [StockPageType] { get }
}

final class StockInfoViewModel: BaseViewModel {
    let stockID: String
    let stockPageTypes: [StockPageType]

    init(stockID: String, stockPageTypes: [StockPageType], appDependencies: AppDependencies) {
        self.stockID = stockID
        self.stockPageTypes = stockPageTypes
        super.init(appDependencies: appDependencies)
    }
}
