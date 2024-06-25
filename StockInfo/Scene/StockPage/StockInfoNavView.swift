//
//  StockInfoNavView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/25.
//

import UIKit
import SnapKit

class StockInfoNavView: UIView {

    var index = 0
    var stockInfos = [StockBaseInfo]()
    var infoDidChanged: ((_ index: Int) -> Void)?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    let leftImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "stockInfo_left_arrow"))
        return imageView
    }()
    let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "stockInfo_right_arrow"))
        return imageView
    }()
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(turnLeft), for: .touchUpInside)
        return button
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(turnRight), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(index: Int, stockInfos: [StockBaseInfo], block: @escaping (_ index: Int) -> Void) {
        self.index = index
        self.stockInfos = stockInfos
        self.infoDidChanged = block
        guard let info = stockInfos[safe: index] else { return }
        setupTitle(info)
    }

    @objc
    func turnLeft() {
        let leftIndex = index - 1
        guard leftIndex >= 0, let info = stockInfos[safe: leftIndex] else { return }
        index = leftIndex
        setupTitle(info)
        infoDidChanged?(index)
    }

    @objc
    func turnRight() {
        let rightIndex = index + 1
        guard rightIndex >= 0, let info = stockInfos[safe: rightIndex] else { return }
        index = rightIndex
        setupTitle(info)
        infoDidChanged?(index)
    }
}

extension StockInfoNavView {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(leftImageView)
        addSubview(rightImageView)
        addSubview(leftButton)
        addSubview(rightButton)

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }

        leftImageView.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(16)
            $0.leading.centerY.equalToSuperview()
        }

        rightImageView.snp.makeConstraints {
            $0.width.equalTo(9)
            $0.height.equalTo(16)
            $0.trailing.centerY.equalToSuperview()
        }

        leftButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(titleLabel.snp.leading)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
        }
    }

    func setupTitle(_ info: StockBaseInfo) {
        let attr = NSMutableAttributedString(string: "\(info.commodity_name)\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        let stockID = NSMutableAttributedString(string: info.commodity_id, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.white])
        attr.append(stockID)
        titleLabel.attributedText = attr
    }
}
