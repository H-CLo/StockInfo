//
//  StockApi.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

protocol StockApi {
    typealias ResponseHandler<Response: Decodable> = Result<Response, Error>
    func fetchStockBaseInfo(completion: @escaping (Result<[StockBaseInfo], any Error>) -> Void)
    func fetchWatchListAll(completion: @escaping (Result<[WatchList], any Error>) -> Void)
    func fetchWatchListStocks(stockIDs: [String], completion: @escaping (Result<[String: WatchListStock], any Error>) -> Void)
}

extension NetworkManager: StockApi {
    func fetchStockBaseInfo(completion: @escaping (Result<[StockBaseInfo], any Error>) -> Void) {
        request(target: Target.stockBaseInfo) { (result: ResponseHandler<[StockBaseInfo]>) in
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchWatchListAll(completion: @escaping (Result<[WatchList], any Error>) -> Void) {
        request(target: Target.watchlistAll) { (result: ResponseHandler<[WatchList]>) in
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func fetchWatchListStocks(stockIDs: [String], completion: @escaping (Result<[String: WatchListStock], any Error>) -> Void) {
        request(target: Target.watchlistStocks, body: WatchListStocksReqModel(stock_ids: stockIDs)) { (result: ResponseHandler<[String: WatchListStock]>) in
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
