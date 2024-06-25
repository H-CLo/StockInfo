//
//  ApiCacheRepository.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

struct ApiCacheRepository<T: TargetType>: AppDirectoryNames, AppFileChecking, AppFileManipulation {
    let target: T

    func save(_ response: Data) {
        guard isEnableCache() else { return }
        let model = ApiCacheModel(date: Date(), data: response)
        createDirectory(.api)
        let fileName = String(describing: target.self)
        let cacheDataPath = buildFullPath(forFileName: fileName, inDirectory: .api)
        do {
            let data = try JSONEncoder().encode(model)
            try writeData(data, at: cacheDataPath)
        } catch {
            debugPrint("Save encode error = \(error.localizedDescription)")
        }
    }

    func load<Resp: Decodable>() -> Resp? {
        // Check enable
        guard isEnableCache() else { return nil }
        let fileName = String(describing: target.self)
        let cacheDataPath = buildFullPath(forFileName: fileName, inDirectory: .api)
        do {
            guard let data = try readData(from: cacheDataPath) else { return nil }
            let decoder = JSONDecoder()
            let cacheModel = try decoder.decode(ApiCacheModel.self, from: data)
            // Check date valid
            guard isDateValid(cacheDate: cacheModel.date) else { return nil }

            let response = try JSONDecoder().decode(Resp.self, from: cacheModel.data)
            return response
        } catch {
            debugPrint("Load encode error = \(error.localizedDescription)")
            return nil
        }
    }

    func isEnableCache() -> Bool {
        guard let type = target as? Target else { return false }
        switch type {
        case .stockBaseInfo:
            return true
        default:
            return false
        }
    }

    func isDateValid(cacheDate: Date) -> Bool {
        guard let type = target as? Target else { return false }
        switch type {
        case .stockBaseInfo:
            return Calendar.current.compare(cacheDate, to: Date(), toGranularity: .day) == .orderedSame
        default:
            return false
        }
    }
}

struct ApiCacheModel: Codable {
    let date: Date
    let data: Data
}
