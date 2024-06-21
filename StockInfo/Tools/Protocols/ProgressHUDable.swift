//
//  ProgressHUDable.swift
//  StockInfo
//
//  Created by Lo on 2024/6/21.
//

import Foundation
import SVProgressHUD

protocol ProgressHUDable: AnyObject {}
extension ProgressHUDable where Self: UIViewController {
    func showSVProgressHUD() {
        SVProgressHUD.setRingRadius(2.0)
        SVProgressHUD.setRingNoTextRadius(14.0)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }

    func dismissSVProgressHUD() {
        SVProgressHUD.dismiss()
    }
}

extension UIViewController: ProgressHUDable {}
