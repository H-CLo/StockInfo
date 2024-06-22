//
//  AppDependencies.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

struct AppDependencies {
    let apiManager: NetworkManager
    let userManager: UserManager

    init(apiManager: NetworkManager = NetworkManager(),
         userManager: UserManager = UserManager()) {
        self.apiManager = apiManager
        self.userManager = userManager
    }
}
