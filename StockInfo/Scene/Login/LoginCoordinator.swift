//
//  LoginCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func loginSuccess()
}

class LoginCoordinator: Coordinator {
    weak var delegate: LoginCoordinatorDelegate?
    let rootViewController: UIViewController

    init(rootViewController: UIViewController, appDependencies: AppDependencies) {
        self.rootViewController = rootViewController
        super.init(navigationController: UINavigationController(), appDependencies: appDependencies)
    }

    override func start() {
        let viewModel = LoginViewModel(appDependencies: appDependencies)
        viewModel.delegate = self
        let loginViewController = LoginViewController(viewModel: viewModel)
        loginViewController.modalPresentationStyle = .overCurrentContext
        rootViewController.present(loginViewController, animated: true)
    }
}

extension LoginCoordinator: LoginViewModelDelegate {
    func loginSuccess() {
        rootViewController.dismiss(animated: true)
        delegate?.loginSuccess()
    }
}
