//
//  BaseViewController.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import UIKit

class BaseViewController<ViewModel: BaseViewModel>: UIViewController {

    let viewModel: ViewModel

    var isLoading: Bool = false {
        didSet {
            isLoading ? showSVProgressHUD() : dismissSVProgressHUD()
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
