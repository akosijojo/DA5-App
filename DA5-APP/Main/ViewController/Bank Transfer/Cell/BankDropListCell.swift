//
//  BankDropListCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/13/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankDropListCell: UICollectionViewCell{
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont(name: Fonts.medium, size: 12)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.bottom.equalTo(self)
        }
        
    }
}
