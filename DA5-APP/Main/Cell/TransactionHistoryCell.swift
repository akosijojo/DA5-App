//
//  TransactionHistoryCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class TransactionHistoryCell: UICollectionViewCell {
    
    var data : TransactionHistoryData? {
        didSet {
            if let d = data {
                self.titleLbl.text = d.title
                self.descLbl.text = d.info
                self.priceLbl.text = d.amount
                self.dateLbl.text = d.date
            }
        }
    }
    
    lazy var titleLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.textColor = ColorConfig().gray
        return v
    }()
    
    lazy var descLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        return v
    }()
    
    lazy var dateLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.textColor = ColorConfig().gray
        v.textAlignment = .right
        return v
    }()
    
    lazy var priceLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.text = "PHP 0.00"
        v.textAlignment = .right
        v.textColor = ColorConfig().lightBlue
        return v
    }()
    
    lazy var bottomLine : UILabel = {
       let v = UILabel()
       v.backgroundColor = ColorConfig().lightGray
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
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        addSubview(descLbl)
        descLbl.snp.makeConstraints { (make) in
           make.top.equalTo(titleLbl.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.width.equalTo(self).multipliedBy(0.6)
           make.height.equalTo(20)
        }
        
        addSubview(dateLbl)
        dateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.width.equalTo(self).multipliedBy(0.4)
            make.height.equalTo(20)
        }
        
        addSubview(priceLbl)
        priceLbl.snp.makeConstraints { (make) in
           make.top.equalTo(dateLbl.snp.bottom)
            make.trailing.equalTo(self).offset(-10)
           make.width.equalTo(self).multipliedBy(0.4)
           make.height.equalTo(20)
        }
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(descLbl.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
        
    }
}
