//
//  Data+.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
              let prettyJSON = String(data: data, encoding: .utf8) else { return nil }
        return prettyJSON
    }
}
