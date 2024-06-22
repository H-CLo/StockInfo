//
//  HomeTabBarController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import UIKit

protocol HomeTabBarControllerDelegate: AnyObject {
    func tabBarDidSelect(_ from: HomeTabBarController, didSelect viewController: UIViewController, index: Int)
}

final class HomeTabBarController: UITabBarController {

    weak var homeTabBarConrollerDelegate: HomeTabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        delegate = self
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        homeTabBarConrollerDelegate?.tabBarDidSelect(self, didSelect: viewController, index: selectedIndex)
    }
}

extension HomeTabBarController {
    func setupUI() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = SColor.backgroundColor
        tabBar.tintColor = SColor.yellowColor
    }
}
