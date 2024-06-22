//
//  HttpClient.swift
//  Pokemon
//
//  Created by Lo on 2024/6/21.
//

import Alamofire
import Foundation

struct EmptyParameter: Encodable {}

enum HTTPResponseError: Error {
    case noData
    case decodeFail(error: String)
}

/// Define http client request function protocol
protocol HttpClientProtocol {
    typealias ResponseHandler<Response: Decodable> = (Result<Response, Error>) -> Void
    static func get<T: TargetType, Response: Decodable>(target: T, completion: @escaping ResponseHandler<Response>)
    static func post<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping ResponseHandler<Response>)
}

/// Http request function definition
class HttpClient: HttpClientProtocol {
    /// Http get request
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - completion: (Result<Response, Error>) -> Void
    static func get<T, Response>(target: T, completion: @escaping ResponseHandler<Response>) where T: TargetType, Response: Decodable {
        request(target: target, body: EmptyParameter(), completion: completion)
    }

    /// Http post request
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - body: Http request body
    ///   - completion: (Result<Response, Error>) -> Void
    static func post<T, Body, Response>(target: T, body: Body, completion: @escaping ResponseHandler<Response>) where T: TargetType, Body: Encodable, Response: Decodable {
        request(target: target, body: body, completion: completion)
    }

    /// Private function to implement http request with Alamofire framewrok
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - body: Http request body
    ///   - completion: (Result<Response, Error>) -> Void
    private static func request<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping (Result<Response, Error>) -> Void) {
        let urlStr = target.baseURL + target.path
        let method = HTTPMethod(rawValue: target.method.rawValue)
        let body = (target.method == .post) ? body : nil
        let headers = HTTPHeaders(target.headers)

        debugPrint("URL = \(urlStr)")
        debugPrint("Method = \(method)")
        debugPrint("Body = \(String(describing: body))")
        debugPrint("Headers = \(headers)")

        AF.request(urlStr,
                   method: method,
                   parameters: body,
                   encoder: JSONParameterEncoder.default,
                   headers: HTTPHeaders(target.headers))
            .response(queue: .main,
                      completionHandler: { response in
                          switch response.result {
                          case let .success(data):
                              do {
                                  if let data = data {
                                      if let prettyJSON = data.prettyPrintedJSONString {
                                          debugPrint("prettyJSON = \(prettyJSON)")
                                      }

                                      let model = try JSONDecoder().decode(Response.self, from: data)
                                      completion(.success(model))
                                  } else {
                                      let error = HTTPResponseError.noData
                                      debugPrint("Api error, target = \(target), error = \(error)")
                                      completion(.failure(error))
                                  }
                              } catch {
                                  let error = HTTPResponseError.decodeFail(error: error.localizedDescription)
                                  debugPrint("Api error, target = \(target), error = \(error)")
                                  completion(.failure(error))
                              }
                          case let .failure(error):
                              debugPrint("Api error, target = \(target), error = \(error)")
                              completion(.failure(error))
                          }
                      })
    }
}
