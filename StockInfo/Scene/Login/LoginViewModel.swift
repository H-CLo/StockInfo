//
//  LoginViewModel.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Combine
import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccess()
}

protocol LoginViewModelSpec {
    // Output
    func login(account: String, password: String)
}

class LoginViewModel: BaseViewModel, LoginViewModelSpec {
    weak var delegate: LoginViewModelDelegate?
    var loginDidSet: PassthroughSubject<Result<Void, Error>, Never> = .init()
}

extension LoginViewModel {
    func login(account: String, password: String) {
        isLoading.send(true)

        apiManager.login(account: account, password: password) { [weak self] result in
            switch result {
            case let .success(model):
                debugPrint("Access = \(model.access)")
                self?.userManager.save(accessToken: model.access)
                self?.delegate?.loginSuccess()
            case let .failure(error):
                self?.apiErrorDidGet.send(error)
            }
            self?.isLoading.send(false)
        }
    }
}
