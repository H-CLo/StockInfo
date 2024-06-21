//
//  LoginReqModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

struct LoginReqModel: Codable {
    let account: String
    let password: String
}

struct LoginResModel: Codable {
    let access: String
}
