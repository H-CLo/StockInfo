//
//  PageListView.swift
//  StockInfo
//
//  Created by Lo on 2024/6/22.
//

import SnapKit
import UIKit

protocol PageListViewDelegate: AnyObject {
    func pageDidSelected(item: PageItemProtocol)
}

class PageListView: UIView {
    var viewModel = PageListViewModel()
    weak var delegate: PageListViewDelegate?

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PageListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PageListCollectionViewCell.self))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 50, height: 40)
        layout.minimumLineSpacing = 5
        return layout
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(items: [PageItemProtocol]) {
        viewModel.setItems(items)
        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
}

extension PageListView {
    func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PageListView: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getSequenceCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PageListCollectionViewCell.self), for: indexPath) as? PageListCollectionViewCell else { return UICollectionViewCell() }
        if let item = viewModel.getSequenceItem(index: indexPath.row) {
            cell.configCell(item: item)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PageListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.getSequenceItem(index: indexPath.row) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.pageDidSelected(item: item)
    }
}
