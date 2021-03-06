//
//  ServicesCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

protocol ServicesDelegate: class {
    func onClickItem(cell: ServicesCell, index: Int?)
}

class ServicesCell: UICollectionViewCell {
    
    var data : ServicesData? {
        didSet {
            if let d = data {
                self.logo.image = UIImage(named: d.image)
                self.logoLbl.text = d.name
            }
        }
    }
     
    var index: Int?
    
    var delegate : ServicesDelegate?
    
    let logo : UIImageView = {
       let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = true
        return v
    }()
    
    let logoLbl : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.font = UIFont(name: Fonts.regular, size: 12)
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
        addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        addSubview(logoLbl)
        logoLbl.snp.makeConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(10)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
    }
    
    @objc func onClick() {
        self.delegate?.onClickItem(cell: self, index: index)
    }
    
}

