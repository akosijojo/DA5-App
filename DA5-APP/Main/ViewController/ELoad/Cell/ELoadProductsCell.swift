//
//  ELoadProductsCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit
protocol ELoadProductsCellDelegate: class {
    func onClick(cell:ELoadProductsCell, data: ELoadProducts?)
}
class ELoadProductsCell: BaseCollectionViewCell {
    var data : ELoadProducts? {
        didSet {
            self.titleLbl.text = data?.productName
            self.descLbl.text = "\(data?.network ?? "") \(data?.productCode ?? "")"
            self.priceLbl.text = (Int(data?.minAmount ?? "0") ?? 0) <= 1 ? "" : "PHP \(data?.minAmount ?? "").00"
        }
    }
    
    weak var delegate : ELoadProductsCellDelegate?
    
    lazy var titleLbl : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 12)
       v.textColor = ColorConfig().black
       return v
    }()

    lazy var descLbl : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.medium, size: 12)
       return v
    }()
   
    lazy var priceLbl : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.medium, size: 12)
       v.textColor = ColorConfig().gray
       v.textAlignment = .right
       return v
    }()
    
    override func setUpView() {
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(self).multipliedBy(0.5)
            make.height.equalTo(20)
        }
        
        addSubview(descLbl)
        descLbl.snp.makeConstraints { (make) in
           make.top.equalTo(titleLbl.snp.bottom)
           make.leading.equalTo(self).offset(20)
           make.width.equalTo(self).multipliedBy(0.5)
           make.height.equalTo(20)
        }
        
        addSubview(priceLbl)
        priceLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-20)
            make.width.equalTo(self).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func onClick() {
        self.delegate?.onClick(cell: self, data: data)
    }
    
}
