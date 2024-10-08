//
//  Coordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import UIKit

protocol Coordinating: AnyObject {
    var childCoordinators: [Coordinating] { get set }
    func start()
}

extension Coordinating {
    func add(child coordinator: Coordinating) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
        debugPrint("childCoordinators = \(childCoordinators)")
    }

    func stopChildren() {
        childCoordinators.removeAll()
    }
}

class Coordinator: Coordinating {
    let navigationController: UINavigationController
    let appDependencies: AppDependencies
    var childCoordinators = [Coordinating]()

    init(navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }

    func start() {
        debugPrint("Coordinator Start")
    }
}

class AppCoordinator: Coordinator {
    private(set) var window: UIWindow?

    init(scene: UIWindowScene, navigationController: UINavigationController, appDependencies: AppDependencies) {
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .white
        self.window = window
        window.makeKeyAndVisible()
        super.init(navigationController: navigationController, appDependencies: appDependencies)
    }

    override func start() {
        // Setup RootViewController
        let tabBarController = HomeTabBarController()
        let rootCoodinator = HomeCoordinator(homeTabBarController: tabBarController,
                                             navigationController: navigationController,
                                             appDependencies: appDependencies)
        window?.rootViewController = tabBarController
        add(child: rootCoodinator)
        rootCoodinator.start()
    }
}
