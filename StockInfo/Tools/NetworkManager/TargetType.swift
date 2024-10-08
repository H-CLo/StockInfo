//
//  TargetType.swift
//  Pokemon
//
//  Created by Lo on 2024/6/21.
//

import Foundation

/// HTTP method
enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

/// Define http request parameters
protocol TargetType {
    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethodType { get }

    /// The headers to be used in the request.
    var headers: [String: String] { get }
}

enum Target {
    /// User login endpoint
    case login
    /// 取得台股 上市/上櫃/興櫃 股票代號 vs. 股票名稱
    case stockBaseInfo
    /// 取得所有 watchlist
    case watchlistAll
    /// 取得 watchlist 中，stock_ids 的參考價、現價、漲跌、漲跌輻
    case watchlistStocks
    /// 取得台股 股票代號 vs. 日走勢資料
    case stockTrend(id: String)

    case stockChart(id: String)
}

extension Target: TargetType {
    var baseURL: String {
        return "https://cmmobile.pythonanywhere.com/"
    }

    var path: String {
        switch self {
        case .login:
            return "auth/login/"
        case .stockBaseInfo:
            return "stockinfo/tw/commoditybaseinfo/"
        case .watchlistAll:
            return "watchlists/info/"
        case .watchlistStocks:
            return "stockinfo/tw/watchliststocks/"
        case .stockTrend(let id):
            return "stockinfo/tw/stockdtrend/\(id)/"
        case .stockChart(let id):
            return "stockinfo/tw/stockkline/v2/\(id)/"
        }
    }

    var method: HTTPMethodType {
        switch self {
        case .stockBaseInfo, .watchlistAll, .stockTrend, .stockChart:
            return .get
        case .login, .watchlistStocks:
            return .post
        }
    }

    var headers: [String: String] {
        return getHeaders()
    }
}

extension Target {
    func getHeaders() -> [String: String] {
        var headers = ["Content-Type": "application/json"]

        // add Token
        switch self {
        case .login:
            break
        default:
            let token = UserManager().loadToken()
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}
