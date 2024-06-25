//
//  AppDirectoryProtocol.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation

enum AppDirectories: String {
    case document = "Documents"
    case api = "Api"
    case temp = "tmp"
}

protocol AppDirectoryNames {
    func documentsDirectoryURL() -> URL
    func apiDirectoryURL() -> URL
    func tempDirectoryURL() -> URL
    func getURL(for directory: AppDirectories) -> URL
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
}

extension AppDirectoryNames {
    func documentsDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func apiDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(component: AppDirectories.api.rawValue)
    }

    func tempDirectoryURL() -> URL {
        return FileManager.default.temporaryDirectory
    }

    func getURL(for directory: AppDirectories) -> URL {
        switch directory {
        case .document:
            return documentsDirectoryURL()
        case .api:
            return apiDirectoryURL()
        case .temp:
            return tempDirectoryURL()
        }
    }

    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL {
        return getURL(for: directory).appending(component: name)
    }
}

protocol AppFileChecking {
    func isExisted(file at: URL) -> Bool
}

extension AppFileChecking {
    func isExisted(file at: URL) -> Bool {
        print("File at path = \(at.path())")
        return FileManager.default.fileExists(atPath: at.path())
    }
}

protocol AppFileManipulation: AppDirectoryNames {
    func createDirectory(url at: URL)
    func createDirectory(_ directory: AppDirectories)
    func writeData(_ data: Data, at url: URL) throws
    func readData(from url: URL) throws -> Data?
}

extension AppFileManipulation {
    func createDirectory(url at: URL) {
        do {
            try FileManager.default.createDirectory(at: at,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            debugPrint("Create directory error = \(error.localizedDescription)")
        }
    }

    func createDirectory(_ directory: AppDirectories) {
        createDirectory(url: getURL(for: directory))
    }

    func writeData(_ data: Data, at url: URL) throws {
        try data.write(to: url)
    }

    func readData(from url: URL) throws -> Data? {
        return try Data(contentsOf: url)
    }
}
