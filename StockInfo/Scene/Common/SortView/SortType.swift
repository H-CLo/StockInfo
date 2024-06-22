//
//  SortType.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

enum SortType {
    case none, up, down

    var imageName: String {
        switch self {
        case .none:
            return "sort_none"
        case .up:
            return "sort_up"
        case .down:
            return "sort_down"
        }
    }
}
