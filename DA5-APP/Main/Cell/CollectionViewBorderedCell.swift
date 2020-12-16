//
//  CollectionViewBorderedCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
class CollectionViewBorderedCell: CollectionViewCell {
    
    let containerView = UIView()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = CGRect(x: 0, y: 5, width: containerView.frame.width, height: containerView.frame.height - 5)
        containerView.layer.shadowPath = UIBezierPath(rect:rect).cgPath
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowOpacity = 0.2
    }
 
   override func setUpView() {
        addSubview(containerView)
        containerView.snp.makeConstraints({ (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        })
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(containerView)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
        })
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOpacity = 1
        collectionView.layer.cornerRadius = 10
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = ColorConfig().lightGray?.cgColor
    
    }
    
}
