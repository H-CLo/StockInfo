//
//  UserManager.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

class UserManager {

    private (set) var account: String = ""
    private (set) var password: String = ""
    private (set) var accessToken: String = ""

    private let saveTokenKey = "saveTokenKey"

    func save(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: saveTokenKey)
    }

    func loadToken() -> String {
        return UserDefaults.standard.string(forKey: saveTokenKey) ?? ""
    }
}
