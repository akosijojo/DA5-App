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


class BankAccountDropListCell: UICollectionViewCell{
//    lazy var bank : DescriptionView = {
//        let v = DescriptionView()
//        v.labelName.font = UIFont(name: Fonts.medium, size: 10)
//        v.labelDesc.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
    
//    lazy var accountNo : DescriptionView = {
//        let v = DescriptionView()
//        v.labelName.font = UIFont(name: Fonts.medium, size: 10)
//        v.labelDesc.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
//
//    lazy var accountName : DescriptionView = {
//        let v = DescriptionView()
//        v.labelName.font = UIFont(name: Fonts.medium, size: 10)
//        v.labelDesc.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
    
     let label = UILabel()
     let bank = UILabel()
     let accountNo = UILabel()
     let accountName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont(name: Fonts.medium, size: 14)
        bank.font = UIFont(name: Fonts.regular, size: 12)
        accountNo.font = UIFont(name: Fonts.regular, size: 12)
        accountName.font = UIFont(name: Fonts.regular, size: 12)
        accountNo.textColor = ColorConfig().lightBlue
//        accountName.textColor = ColorConfig().lightBlue
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
//        addSubview(bank)
//        bank.snp.makeConstraints { (make) in
//            make.top.equalTo(self)
//            make.leading.equalTo(self).offset(10)
//            make.trailing.equalTo(self).offset(-10)
//            make.height.equalTo(30)
//        }
//        addSubview(accountNo)
//        accountNo.snp.makeConstraints { (make) in
//            make.top.equalTo(bank.snp.bottom)
//            make.leading.equalTo(self).offset(10)
//            make.trailing.equalTo(self).offset(-10)
//            make.height.equalTo(30)
//        }
//        addSubview(accountName)
//        accountName.snp.makeConstraints { (make) in
//            make.top.equalTo(accountNo.snp.bottom)
//            make.leading.equalTo(self).offset(10)
//            make.trailing.equalTo(self).offset(-10)
//            make.height.equalTo(30)
//        }
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        addSubview(bank)
        bank.snp.makeConstraints { (make) in
           make.top.equalTo(label.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.trailing.equalTo(self).offset(-10)
           make.height.equalTo(20)
        }
        addSubview(accountNo)
        accountNo.snp.makeConstraints { (make) in
           make.top.equalTo(bank.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.trailing.equalTo(self).offset(-10)
           make.height.equalTo(20)
        }
        addSubview(accountName)
        accountName.snp.makeConstraints { (make) in
           make.top.equalTo(accountNo.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.trailing.equalTo(self).offset(-10)
           make.height.equalTo(20)
        }
    }
}


class DescriptionView : UIView {
    let labelName = UILabel()
    let labelDesc = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpView() {
        addSubview(labelName)
        labelName.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.5)
        }
        addSubview(labelDesc)
        labelDesc.snp.makeConstraints { (make) in
            make.top.equalTo(labelName.snp.bottom)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
}
