//
//  PageListCollectionViewCell.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import SnapKit
import UIKit

class PageListCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? SColor.yellowColor : SColor.grayColor1
            underlineView.backgroundColor = isSelected ? SColor.yellowColor : UIColor.clear
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = SColor.grayColor1
        label.numberOfLines = 1
        return label
    }()

    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    func configCell(item: PageItemProtocol) {
        titleLabel.text = item.title
    }
}

private extension PageListCollectionViewCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }

        underlineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel).inset(2)
            $0.height.equalTo(3)
            $0.bottom.equalToSuperview()
        }
    }
}
