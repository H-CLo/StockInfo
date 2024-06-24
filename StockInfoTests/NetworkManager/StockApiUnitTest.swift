//
//  StockApiUnitTest.swift
//  StockInfoTests
//
//  Created by Lo on 2024/6/22.
//

@testable import StockInfo
import XCTest

final class StockApiUnitTest: XCTestCase {

    let network = NetworkManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchStockBaseInfo() {
        let expec = XCTestExpectation(description: "test_fetchStockBaseInfo")
        network.fetchStockBaseInfo(completion: { result in
            switch result {
            case .success(let model):
                debugPrint("model = \(model)")
                XCTAssert(model.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_fetchWatchlistAll() {
        let expec = XCTestExpectation(description: "test_fetchWatchlistAll")
        network.fetchWatchListAll(completion: { result in
            switch result {
            case .success(let model):
                debugPrint("model = \(model)")
                //XCTAssert(model.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_fetchWatchlistStocks() {
        let expec = XCTestExpectation(description: "test_fetchWatchlistStocks")
        network.fetchWatchListStocks(stockIDs: ["2330", "2303", "2603"], completion: { result in
            switch result {
            case .success(let model):
                debugPrint("model = \(model)")
                //XCTAssert(model.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_fetchStockTrend() {
        let expec = XCTestExpectation(description: "test_fetchStockTrend")
        network.fetchStockTrend(stockID: "2330", completion: { result in
            switch result {
            case .success(let model):
                debugPrint("model = \(model)")
                //XCTAssert(model.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_fetchStockChart() {
        let expec = XCTestExpectation(description: "test_fetchStockChart")
        network.fetchStockChart(stockID: "2330", completion: { result in
            switch result {
            case .success(let model):
                debugPrint("model = \(model)")
                //XCTAssert(model.count > 0)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }
}
