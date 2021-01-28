//
//  PaybillsCategoryCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PaybillsCategoryCellDelegate : class {
    func onClick(cell: PaybillsCategoryCell, index: Int?)
}

class PaybillsCategoryCell: UICollectionViewCell {
    
    var data : String? {
        didSet {
            self.category.text = data
//            if data.isActive{
//                self.selectedItem()
//            }
        }
    }
    
    var index : Int? = 0
    
    var delegate : PaybillsCategoryCellDelegate?
    
    lazy var category : UILabel = {
       let v = UILabel()
        v.layer.cornerRadius = 20
        v.backgroundColor = ColorConfig().white
        v.layer.borderWidth = 1
        v.textColor = ColorConfig().black
        v.font = UIFont(name: Fonts.medium, size: 16)
        v.layer.borderColor = ColorConfig().lightGray?.cgColor
        v.textAlignment = .center
        v.clipsToBounds = true
        
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
        addSubview(category)
        category.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        category.isUserInteractionEnabled = true
        category.addGestureRecognizer(tap)
    }
    
    @objc func onClick() {
        self.delegate?.onClick(cell: self, index: index)
    }
    
    func selectedItem(isActive: Bool) {
        self.category.backgroundColor = isActive ? ColorConfig().black : ColorConfig().white
        self.category.textColor = isActive ? ColorConfig().white : ColorConfig().black
        self.layer.borderColor = isActive ? ColorConfig().black?.cgColor : ColorConfig().lightGray?.cgColor
    }
}
