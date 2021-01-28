//
//  PaybillsHorizontalCollectionCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PaybillsHorizontalCollectionCellDelegate: class {
    func onClickShowView(cell: PaybillsHorizontalCollectionCell, index: Int)
}

class PaybillsHorizontalCollectionCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PaybillsCategoryCell else {
            return UICollectionViewCell()
        }
        cell.data = self.data?[indexPath.item]
        cell.index = indexPath.item
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.data?[indexPath.item].widthForView(font: UIFont(name: Fonts.medium, size: 16)!, width: collectionView.frame.width) ?? 0
        return CGSize(width: width + 20, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    weak var delegate : PaybillsHorizontalCollectionCellDelegate?
    
    var section : Int?
    
    var cellId = "cellId"
    
    var data : [String]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = ColorConfig().white
       return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaybillsCategoryCell.self, forCellWithReuseIdentifier: cellId)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        })
    }
    
}

extension PaybillsHorizontalCollectionCell: PaybillsCategoryCellDelegate {
    func onClick(cell: PaybillsCategoryCell, index: Int?) {
        if let item = index {
            self.delegate?.onClickShowView(cell: self, index: item)
            cell.selectedItem(isActive: true)
        }
    }
    
}



