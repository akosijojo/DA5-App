//
//  ServicesCollectionView.swift
//  DA5-APP
//
//  Created by Jojo on 12/16/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class ServicesCollectionViewCell : CollectionViewBorderedCell {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return servicesData?.count ?? 0
    }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: servicesCellId, for: indexPath) as? ServicesCell else {
               return UICollectionViewCell()
           }
            cell.data = servicesData?[indexPath.item]
            cell.delegate = self
            cell.index = indexPath.item
           return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 20 , height: 80)
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
    }

    func setUpCollectionView() {
        if let layout  = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ServicesCell.self, forCellWithReuseIdentifier: servicesCellId)
    }
}

