//
//  BaseViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import Combine

class BaseViewModel {
    let appDependencies: AppDependencies
    let apiManager: NetworkManager
    let userManager: UserManager

    var isLoading: PassthroughSubject<Bool, Never> = .init()

    init(appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.apiManager = appDependencies.apiManager
        self.userManager = appDependencies.userManager
    }
}
