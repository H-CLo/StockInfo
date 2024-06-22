//
//  LoginApiUnitTest.swift
//  StockInfoTests
//
//  Created by Lo on 2024/6/21.
//

@testable import StockInfo
import XCTest

final class LoginApiUnitTest: XCTestCase {

    let network = NetworkManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_login() {
        let expec = XCTestExpectation(description: "test_login")
        network.login(account: "interviewer", password: "Aa12345678",
                      completion: { result in
            switch result {
            case .success(let model):
                XCTAssert(model.access.count > 0)
                let access = model.access
                debugPrint("access = \(access)")
                UserManager().save(accessToken: model.access)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }
}
