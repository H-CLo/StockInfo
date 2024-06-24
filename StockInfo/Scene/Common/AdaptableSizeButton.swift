//
//  AdaptableSizeButton.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import Foundation
import UIKit

class AdaptableSizeButton: UIButton {
    var extendWidth: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + extendWidth + titleEdgeInsets.right,
                                       height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        return desiredButtonSize
    }
}
