//
//  StockListTableViewCell.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import SnapKit
import UIKit

class StockListTableViewCell: UITableViewCell {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let upDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        priceLabel.text = ""
        priceLabel.textColor = .white
        upDownLabel.text = ""
        upDownLabel.textColor = .white
    }

    func configCell(info: StockListInfo) {
        // Name label
        let nameAttr = NSMutableAttributedString(string: info.baseInfo.commodity_name,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        nameAttr.append(NSAttributedString(string: "\n\(info.baseInfo.commodity_id)",
                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), .foregroundColor: SColor.grayColor1]))
        nameLabel.attributedText = nameAttr

        // Price
        priceLabel.text = info.stock.currentPrice
        priceLabel.textColor = info.upDown.color

        upDownLabel.text = "\(info.upDown.triangleSymbol) \(info.stock.diff)\n\(info.stock.diffRatio)"
        upDownLabel.textColor = info.upDown.color
    }
}

private extension StockListTableViewCell {
    func setupUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(upDownLabel)
    }
}
