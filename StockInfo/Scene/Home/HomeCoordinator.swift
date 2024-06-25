//
//  HomeCoordinator.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {

    private let homeTabBarController: HomeTabBarController

    init(homeTabBarController: HomeTabBarController, navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.homeTabBarController = homeTabBarController
        super.init(navigationController: navigationController, appDependencies: appDependencies)
        homeTabBarController.homeTabBarConrollerDelegate = self
    }

    override func start() {
        // Flow
        // Login success -> display tabBar
        let loginCoordinator = makeLoginCoordinator()
        add(child: loginCoordinator)
        loginCoordinator.start()
    }

    func startTabBar() {
        let items: [TabItem] = TabItem.allCases
        let dataSource = items.map { $0.makeCoordinator(appDependencies: appDependencies) }
        let viewControllers = dataSource.map { $0.navigationController }
        let coordinators = dataSource.map { $0.coordinator }

        homeTabBarController.viewControllers = viewControllers
        coordinators.forEach { add(child: $0) }

        // 自選股
        let index = 1
        homeTabBarController.selectedIndex = index
        coordinators[index].start()
    }
}

// MARK: - TabItem

private extension HomeCoordinator {
    enum TabItem: Int, CaseIterable {
        /// 選股
        case screen
        /// 自選股
        case watchlist
        /// 社團
        case society
        /// 內容專區
        case news
        /// 更多
        case more

        var imageName: String {
            switch self {
            case .screen:
                return "tab_screen_unselected"
            case .watchlist:
                return "tab_watchlist_selected"
            case .society:
                return "tab_society_unselected"
            case .news:
                return "tab_news_unselected"
            case .more:
                return "tab_more_unselected"
            }
        }

        var title: String {
            switch self {
            case .screen:
                return LocalizeTool.string("選股")
            case .watchlist:
                return LocalizeTool.string("自選股")
            case .society:
                return LocalizeTool.string("社團")
            case .news:
                return LocalizeTool.string("內容專區")
            case .more:
                return LocalizeTool.string("更多")
            }
        }

        // TODO: - Other views
        func makeCoordinator(appDependencies: AppDependencies) -> (navigationController: UINavigationController, coordinator: Coordinator) {
            switch self {
            case .screen, .society, .news, .more:
                let navigationController = UINavigationController()
                let coordinator = Coordinator(navigationController: navigationController, appDependencies: appDependencies)
                navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), tag: self.rawValue)
                return (navigationController, coordinator)
            case .watchlist:
                let navigationController = UINavigationController()
                let coordinator = StockListCoordinator(navigationController: navigationController, appDependencies: appDependencies)
                navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), tag: self.rawValue)
                return (navigationController, coordinator)
            }
        }
    }
}

// MARK: - Login Coordinator

private extension HomeCoordinator {
    func makeLoginCoordinator() -> Coordinator {
        let coordinator = LoginCoordinator(rootViewController: homeTabBarController, appDependencies: appDependencies)
        coordinator.delegate = self
        return coordinator
    }
}

extension HomeCoordinator: LoginCoordinatorDelegate {
    func loginSuccess() {
        stopChildren()
        startTabBar()
    }
}

extension HomeCoordinator: HomeTabBarControllerDelegate {
    func tabBarDidSelect(_ from: HomeTabBarController, didSelect viewController: UIViewController, index: Int) {
        guard (viewController as? UINavigationController)?.viewControllers.isEmpty ?? false == true else { return }
        childCoordinators[index].start()
    }
}
