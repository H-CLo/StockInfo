//
//  LoginApi.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

protocol LoginApi {
    typealias ResponseHandler<Response: Decodable> = Result<Response, Error>
    func login(account: String, password: String, completion: @escaping (Result<LoginResModel, Error>) -> Void)
}

extension NetworkManager: LoginApi {
    func login(account: String, password: String, completion: @escaping (Result<LoginResModel, any Error>) -> Void) {
        let reqModel = LoginReqModel(account: account, password: password)
        request(target: Target.login, body: reqModel) { (result: ResponseHandler<LoginResModel>) in
            switch result {
            case let .success(model):
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
