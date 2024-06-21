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
}

extension Target: TargetType {
    var baseURL: String {
        switch self {
        case .login:
            return "https://cmmobile.pythonanywhere.com/"
        }
    }

    var path: String {
        switch self {
        case .login:
            return "auth/login/"
        }
    }

    var method: HTTPMethodType {
        switch self {
        case .login:
            return .post
        }
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
