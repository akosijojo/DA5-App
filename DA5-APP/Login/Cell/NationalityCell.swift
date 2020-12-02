//
//  NationalityCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/26/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class NationalityCell: UICollectionViewCell {
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
