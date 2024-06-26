//
//  CustomCandleStickChartView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/26.
//

import DGCharts
import Foundation
import UIKit

class CustomCandleStickChartView: CandleStickChartView {

    var chartDatas: [StockChartModel.ChartData] = []

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
        addLongPressRecognizer()
        addSubview(highlightCircle)
        addSubview(valueLabel)
        addSubview(dateLabel)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesBegan(touches, withEvent: event)
        //hideLongPressedHighlight()
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

            showHighlightCircle(x: h?.xPx ?? 0, y: h?.yPx ?? 0)
            showValueLabel(x: viewPortHandler.contentRight, y: h?.yPx ?? 0, text: h?.y.description ?? "")
            let index = Int(h?.x ?? 0)
            showDateLabel(x: h?.xPx ?? 0, y: viewPortHandler.contentBottom, text: chartDatas[safe: index]?.date ?? "")
        }
    }

    func showHighlightCircle(x: CGFloat, y: CGFloat) {
        highlightCircle.frame.origin = CGPoint(x: x - 2, y: y - 2)
        highlightCircle.isHidden = false
    }

    func showValueLabel(x: CGFloat, y: CGFloat, text: String) {
        valueLabel.frame.origin = CGPoint(x: x, y: y)
        valueLabel.text = text
        valueLabel.sizeToFit()
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

    func hideLongPressedHighlight() {
        highlightCircle.isHidden = true
        valueLabel.isHidden = true
        dateLabel.isHidden = true
    }
}
