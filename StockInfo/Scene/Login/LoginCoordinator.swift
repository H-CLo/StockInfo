//
//  LoginCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation

class LoginCoordinator: Coordinator {
    
    override func start() {
        let viewModel = LoginViewModel(appDependencies: appDependencies)
        let loginViewController = LoginViewController(viewModel: viewModel)
        loginViewController.modalPresentationStyle = .overCurrentContext
        loginViewController.delegate = self
        navigationController.present(loginViewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginSuccess() {
        // TODO: dismiss
    }
}
