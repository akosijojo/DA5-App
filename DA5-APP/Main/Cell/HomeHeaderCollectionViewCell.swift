//
//  HomeHeaderCollectionViewCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/18/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

protocol HomeHeaderCollectionViewCellDelegate: class {
    func onClickMenu(cell: HomeHeaderCollectionViewCell)
}

class HomeHeaderCollectionViewCell: UICollectionReusableView {
    weak var delegate: HomeHeaderCollectionViewCellDelegate?
    
    let logo : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "app_logo")
        return v
    }()
    let menu : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "menu")
        return v
    }()
    
    let background : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "img_city")
        return v
    }()
    
    let balanceView : UIView = {
       let v = UIView()
        v.layer.cornerRadius = 10
        v.backgroundColor = .white
        v.layer.shadowOpacity = 1
        return v
    }()
       
    let maintainingBalance : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 28)
        v.textAlignment = .center
        v.text = "0.00 PHP"
        return v
    }()
    
    let balancelbl : UILabel = {
       let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 16)
        v.textAlignment = .center
        v.text = "Wallet Balance"
       return v
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        balanceView.layer.shadowPath = UIBezierPath(rect: balanceView.bounds).cgPath
        balanceView.layer.shadowRadius = 5
        balanceView.layer.shadowOffset = .zero
        balanceView.layer.shadowOpacity = 0.5
    }
    
    func setUpView() {
        addSubview(menu)
        addSubview(logo)
        addSubview(background)
        addSubview(balanceView)
        balanceView.addSubview(maintainingBalance)
        balanceView.addSubview(balancelbl)
        
        background.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-80)
        }
        
        menu.snp.makeConstraints { (make) in
            make.top.equalTo(background.snp.top).offset(20)
            make.leading.equalTo(background.snp.leading).offset(20)
            make.width.equalTo(25)
            make.height.equalTo(30)
        }

        logo.snp.makeConstraints { (make) in
           make.top.equalTo(background.snp.top).offset(20)
           make.centerX.equalTo(background)
           make.width.equalTo(65)
           make.height.equalTo(35)
        }
        self.bringSubviewToFront(logo)
        
        balanceView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.height.equalTo(self).multipliedBy(0.50)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
        }
        
        maintainingBalance.snp.makeConstraints { (make) in
           make.top.equalTo(balanceView).offset(20)
           make.leading.equalTo(balanceView).offset(10)
           make.trailing.equalTo(balanceView).offset(-10)
           make.height.equalTo(balanceView).multipliedBy(0.5)
        }
        
        balancelbl.snp.makeConstraints { (make) in
           make.bottom.equalTo(balanceView).offset(-10)
           make.leading.equalTo(balanceView).offset(10)
           make.trailing.equalTo(balanceView).offset(-10)
           make.height.equalTo(20)
        }
        
        let onClick = UITapGestureRecognizer(target: self, action:#selector(onClickMenuIcon))
        menu.isUserInteractionEnabled = true
        menu.addGestureRecognizer(onClick)
    }
    
    @objc func onClickMenuIcon() {
        self.delegate?.onClickMenu(cell: self)
    }
    
}
