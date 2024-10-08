//
//  NetworkManager.swift
//  Pokemon
//
//  Created by Lo on 2024/6/21.
//

import Alamofire
import Foundation

/// Network service
class NetworkManager {

    /// Network request service
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - body: Http request body
    ///   - completion: (Result<Response, Error>) -> Void
    func request<T: TargetType, Body: Encodable, Response: Decodable>(target: T,
                                                                      body: Body = EmptyParameter(),
                                                                      completion: @escaping (Result<Response, Error>) -> Void)
    {
        switch target.method {
        case .get:
            HttpClient.get(target: target, completion: completion)
        case .post:
            HttpClient.post(target: target, body: body, completion: completion)
        }
    }
}
