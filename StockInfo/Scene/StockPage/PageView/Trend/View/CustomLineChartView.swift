//
//  CustomLineChartView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/26.
//

import DGCharts
import Foundation
import UIKit

class CustomLineChartView: LineChartView {
    var refPrice: Double = 0

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    lazy var infoView: InfoView = {
        let view = InfoView(frame: .zero)
        view.isHidden = true
        return view
    }()

    lazy var highlightCircle: UIView = {
        let view = UIView()
        view.backgroundColor = SColor.yellowColor1
        view.frame.size = CGSize(width: 4, height: 4)
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = SColor.yellowColor1
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = SColor.yellowColor1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addLongPressRecognizer()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chartLongPressed))
        longPressRecognizer.minimumPressDuration = 0.1
        addGestureRecognizer(longPressRecognizer)
    }

    @objc func chartLongPressed(_ sender: UILongPressGestureRecognizer) {
        if data === nil {
            return
        }

        if sender.state == NSUIGestureRecognizerState.ended {
            let h = getHighlightByTouchPoint(sender.location(in: self))

            if h === nil || h == lastHighlighted {
                lastHighlighted = nil
                highlightValue(nil, callDelegate: true)
            } else {
                lastHighlighted = h
                highlightValue(h, callDelegate: true)
            }

            showInfoView(x: viewPortHandler.contentRight, y: viewPortHandler.contentTop, xValue: h?.x ?? 0, yValue: h?.y ?? 0)
            showHighlightCircle(x: h?.xPx ?? 0, y: h?.yPx ?? 0)
            showValueLabel(x: viewPortHandler.contentLeft, y: h?.yPx ?? 0, text: h?.y.interceptDecimal() ?? "")
            showDateLabel(x: h?.xPx ?? 0, y: viewPortHandler.contentBottom, text: dateFormatter.string(from: Date(timeIntervalSince1970: h?.x ?? 0)))
        }
    }

    func setupUI() {
        addSubview(infoView)
        addSubview(highlightCircle)
        addSubview(valueLabel)
        addSubview(dateLabel)
    }

    /// 這邊給個X, Y position 是畫面右側與上方的位置
    func showInfoView(x: CGFloat, y: CGFloat, xValue: Double, yValue: Double) {
        let height: CGFloat = 60
        let width: CGFloat = 90
        infoView.frame = CGRect(origin: CGPoint(x: x - width - 3, y: y - 3), size: CGSize(width: width, height: height))
        infoView.timeLabel.text = "\(LocalizeTool.string("時間")) : \(dateFormatter.string(from: Date(timeIntervalSince1970: xValue)))"
        infoView.priceLabel.text = "\(LocalizeTool.string("股價")) : \(yValue.interceptDecimal())"
        let diff = yValue - refPrice
        let percent = (diff / refPrice) * 100
        let upDown = StockUpDown(diffPrice: diff.description)
        infoView.upDownLabel.text = "\(upDown.triangleSymbol) \(diff.interceptDecimal(minDigits: 1, maxDigits: 1)) (\(percent.interceptDecimal())%)"
        infoView.upDownLabel.textColor = upDown.color
        infoView.isHidden = false
    }

    func showHighlightCircle(x: CGFloat, y: CGFloat) {
        highlightCircle.frame.origin = CGPoint(x: x - 2, y: y - 2)
        highlightCircle.isHidden = false
    }

    func showValueLabel(x: CGFloat, y: CGFloat, text: String) {
        valueLabel.frame.origin = CGPoint(x: x, y: y)
        valueLabel.text = text
        valueLabel.sizeToFit()
        let x = valueLabel.frame.origin.x - valueLabel.frame.size.width
        valueLabel.frame.origin.x = x
        let y = valueLabel.frame.origin.y - valueLabel.frame.size.height / 2
        valueLabel.frame.origin.y = y
        valueLabel.isHidden = false
    }

    func showDateLabel(x: CGFloat, y: CGFloat, text: String) {
        dateLabel.frame.origin = CGPoint(x: x, y: y)
        dateLabel.text = text
        dateLabel.sizeToFit()
        let x = dateLabel.frame.origin.x - dateLabel.frame.size.width / 2
        dateLabel.frame.origin.x = x
        dateLabel.isHidden = false
    }
}

extension CustomLineChartView {
    class InfoView: UIView {
        lazy var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            return stackView
        }()

        lazy var timeLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()

        lazy var priceLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()

        lazy var upDownLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            return label
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupLayout()
            setupUI()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupLayout() {
            layer.cornerRadius = 4
            layer.borderWidth = 1
            layer.borderColor = SColor.grayColor2.cgColor
            backgroundColor = SColor.backgroundColor2
        }

        func setupUI() {
            addSubview(stackView)
            stackView.addArrangedSubview(timeLabel)
            stackView.addArrangedSubview(priceLabel)
            stackView.addArrangedSubview(upDownLabel)

            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            timeLabel.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
            priceLabel.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
            upDownLabel.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
        }
    }
}
