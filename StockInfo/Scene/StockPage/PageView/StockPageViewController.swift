//
//  StockPageViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/23.
//

import UIKit

class StockPageViewController: UIPageViewController {

    private (set) var viewControllerList: [UIViewController] = [UIViewController]()
    //weak var pageViewControllerDelegate: PageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }

    func setupViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllerList = viewControllers
    }

    func start() {
        guard let first = viewControllerList.first else { return }
        self.setViewControllers([first], direction: .forward, animated: false)
    }
}

extension StockPageViewController: UIPageViewControllerDataSource {
    /// 上一頁
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - viewController: _
    /// - Returns: _
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // 取得當前頁數的 index(未翻頁前)
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }

        // 設定上一頁的 index
        let priviousIndex: Int = currentIndex - 1

        // 判斷上一頁的 index 是否小於 0，若小於 0 則停留在當前的頁數
        return priviousIndex < 0 ? nil : self.viewControllerList[priviousIndex]
    }

    /// 下一頁
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - viewController: _
    /// - Returns: _
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // 取得當前頁數的 index(未翻頁前)
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }

        // 設定下一頁的 index
        let nextIndex: Int = currentIndex + 1

        // 判斷下一頁的 index 是否大於總頁數，若大於則停留在當前的頁數
        return nextIndex > self.viewControllerList.count - 1 ? nil : self.viewControllerList[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension StockPageViewController: UIPageViewControllerDelegate {

    /// 切換完頁數觸發的 func
    ///
    /// - Parameters:
    ///   - pageViewController: _
    ///   - finished: _
    ///   - previousViewControllers: _
    ///   - completed: _
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // 取得當前頁數的 viewController
        guard let currentViewController: UIViewController = self.viewControllers?.first else { return }

        // 取得當前頁數的 index
        guard let currentIndex = viewControllerList.firstIndex(of: currentViewController) else { return }

        // 設定 RootViewController 上 PageControl 的頁數
        //self.pageViewControllerDelegate?.pageViewController(self, didUpdatePageIndex: currentIndex)
    }
}
