//
//  SortableView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import Combine
import SnapKit
import UIKit

protocol SortableColumnProtocol {
    var id: Int { get }
    var title: String { get }
}

final class SortableView<ColumnType: SortableColumnProtocol>: UIView {
    private(set) var sortType: SortType = .none {
        didSet {
            sortTypeDidSet.send((columnType, sortType))
            sortImageView.image = UIImage(named: sortType.imageName)
        }
    }

    private(set) var columnType: ColumnType?

    var sortTypeDidSet: PassthroughSubject<(ColumnType?, SortType), Never> = .init()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = SColor.grayColor1
        label.numberOfLines = 1
        return label
    }()

    let sortImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sort_none"))
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
        isUserInteractionEnabled = true
        addTapGesture()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Tap

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        addGestureRecognizer(tap)
    }

    /// Spec: Default -> up -> down
    @objc
    private func viewDidTapped() {
        switch sortType {
        case .none:
            sortType = .up
        case .up:
            sortType = .down
        case .down:
            sortType = .none
        }
    }

    // Internal

    func setColumnType(_ type: ColumnType) {
        columnType = type
        titleLabel.text = type.title
    }
}

// MARK: - UI

private extension SortableView {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(sortImageView)

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        sortImageView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(8)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.centerY.equalTo(titleLabel)
        }
    }
}
