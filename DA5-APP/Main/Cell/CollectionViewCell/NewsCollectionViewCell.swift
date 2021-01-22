//
//  NewsCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 12/16/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class NewsCollectionViewCell : CollectionViewCell {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsData?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as? NewsCell else {
              return UICollectionViewCell()
          }
           cell.data = newsData?[indexPath.item]
           cell.delegate = self
           cell.index = indexPath.item
          return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             return CGSize(width: collectionView.frame.width * 0.6, height: 180)
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
        
    func setUpCollectionView() {
        if let layout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection =  .horizontal
            layout.minimumLineSpacing = 20
        }
        collectionView.delegate = self
        collectionView.dataSource = self
            collectionView.register(NewsCell.self, forCellWithReuseIdentifier: newsCellId)
    }
}
