//
//  CollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol CollectionViewCellDelegate: class {
    func onClickShowView(cell: UICollectionViewCell, type: Int, index: Int)
}

class CollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section {
        case 1:
            return servicesData?.count ?? 0
        case 4:
            return tHistoryData?.count ?? 0
        default:
            return self.section == 2 ? newsData?.count ?? 0 : pTransactionsData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch section {
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: servicesCellId, for: indexPath) as? ServicesCell else {
               return UICollectionViewCell()
           }
            cell.data = servicesData?[indexPath.item]
            cell.delegate = self
            cell.index = indexPath.item
           return cell
        case 2:
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as? NewsCell else {
              return UICollectionViewCell()
          }
           cell.data = newsData?[indexPath.item]
           cell.delegate = self
           cell.index = indexPath.item
          return cell
        case 3:
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pTransactionCellId, for: indexPath) as? PendingTransactionCell else {
             return UICollectionViewCell()
         }
          cell.data = pTransactionsData?[indexPath.item]
          cell.delegate = self
          cell.index = indexPath.item
         return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tHistoryCellId, for: indexPath) as? TransactionHistoryCell else {
                return UICollectionViewCell()
            }
            cell.data = tHistoryData?[indexPath.item]
            cell.delegate = self
            cell.index = indexPath.item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch section {
        case 1:
            return CGSize(width: (collectionView.frame.width / 3) - 20 , height: 80)
        case 4:
            let width = collectionView.frame.width
            return CGSize(width: width, height: 80)
        default:
             return CGSize(width: collectionView.frame.width * 0.7, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.section {
        case 1:
            return UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        case 4:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
             return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    weak var delegate : CollectionViewCellDelegate?
    
    var section : Int?
    
    var cellId = "cellId"
    var servicesCellId = "cellId"
    var newsCellId = "cellId"
    var pTransactionCellId = "cellId"
    var tHistoryCellId = "cellId"
    
    var servicesData : [ServicesData]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var newsData : [NewsData]?{
        didSet {
            self.collectionView.reloadData()
        }
    }
    var pTransactionsData : [PendingTransactionsData]?{
        didSet {
            self.collectionView.reloadData()
        }
    }
    var tHistoryData : [TransactionHistoryData]?{
        didSet {
            print("RELOAD")
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.bounces = false
        v.showsHorizontalScrollIndicator = false
        v.backgroundColor = ColorConfig().white
       return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func setUpCollectionView(type: Int) {
        if let layout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = type == 2 || type == 3 ? .horizontal : .vertical
            layout.minimumLineSpacing = type == 2 || type == 3 ? 20 : type == 1 ? 10 : 0
        }
        collectionView.delegate = self
        collectionView.dataSource = self
       
        
//        switch type {
//        case 1:
            collectionView.register(ServicesCell.self, forCellWithReuseIdentifier: servicesCellId)
//        case 2:
            collectionView.register(NewsCell.self, forCellWithReuseIdentifier: newsCellId)
//        case 3:
            collectionView.register(PendingTransactionCell.self, forCellWithReuseIdentifier: pTransactionCellId)
//        default:
             collectionView.register(TransactionHistoryCell.self, forCellWithReuseIdentifier: tHistoryCellId)
//        }
        
    }
    
}

extension CollectionViewCell: NewsCellDelegate ,ServicesDelegate, PendingTransactionDelegate, TransactionHistoryDelegate{
    
    func onClickItem(cell: ServicesCell, index: Int?) {
        if let item = index{
            self.delegate?.onClickShowView(cell: cell, type: 1, index: item)
        }
    }
    
    func onClickItem(cell: NewsCell, index: Int?, type: Int) {
        if let item = index{
            self.delegate?.onClickShowView(cell: cell, type: type, index: item)
        }
    }

    func onClickItem(cell: PendingTransactionCell, index: Int?) {
         if let item = index{
            self.delegate?.onClickShowView(cell: cell, type: 3, index: item)
         }
    }
    
    func removeItem(cell: PendingTransactionCell, index: Int?) {
        if let item = index {
            //MARK: - show alert
            print("REMOVING TRANSACTION AT \(item)")
        }
    }
       
       
    func onClickItem(cell: TransactionHistoryCell, index: Int?) {
         if let item = index{
            self.delegate?.onClickShowView(cell: cell, type: 4, index: item)
        }
    }
    
}


