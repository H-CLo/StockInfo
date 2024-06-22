//
//  PageListViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Foundation

protocol PageItemProtocol {
    var index: Int { get }
    var title: String { get }
}

final class PageListViewModel {
    var pageItems = [PageItemProtocol]()

    func setItems(_ items: [PageItemProtocol]) {
        pageItems = items
    }
}

extension PageListViewModel {
    func getSequenceCount() -> Int {
        return pageItems.count
    }

    func getSequenceItem(index: Int) -> PageItemProtocol? {
        return pageItems[safe: index]
    }
}
