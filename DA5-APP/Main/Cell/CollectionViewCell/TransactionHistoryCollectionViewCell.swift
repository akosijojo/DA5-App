//
//  TransactionHistoryCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 12/16/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class TransactionHistoryCollectionViewCell : CollectionViewBorderedCell {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tHistoryData?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tHistoryCellId, for: indexPath) as? TransactionHistoryCell else {
            return UICollectionViewCell()
        }
        cell.data = tHistoryData?[indexPath.item]
        cell.delegate = self
        cell.index = indexPath.item
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 80)
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setUpCollectionView() {
        if let layout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing =  0
        }
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(TransactionHistoryCell.self, forCellWithReuseIdentifier: tHistoryCellId)
    }
        
}
