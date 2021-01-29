//
//  PaybillsCategoryCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PaybillsCategoryCellDelegate : class {
    func onClick(cell: PaybillsCategoryCell, data: CategoryData?)
}

class PaybillsCategoryCell: UICollectionViewCell {
    
    var data : CategoryData? {
        didSet {
            self.category.text = data?.rawValue
        }
    }
    
    var index : Int? = 0
    
    var delegate : PaybillsCategoryCellDelegate?
    
    lazy var view : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 15
        v.clipsToBounds = true
        return v
    }()
    
    lazy var category : UILabel = {
       let v = UILabel()
        v.layer.cornerRadius = 15
        v.backgroundColor = ColorConfig().white
//        v.layer.borderWidth = 1
        v.textColor = ColorConfig().black
        v.font = UIFont(name: Fonts.medium, size: 14)
//        v.layer.borderColor = ColorConfig().lightGray?.cgColor
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = 15
        view.layer.borderColor = ColorConfig().lightGray?.cgColor
        let rect = CGRect(x: 0, y: 5, width: view.frame.width, height: view.frame.height - 5)
        view.layer.shadowPath = UIBezierPath(rect:rect).cgPath
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
    }
    
    func setUpView() {
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
        view.addSubview(category)
        category.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(2.5)
            make.leading.equalTo(view).offset(1)
            make.trailing.equalTo(view).offset(-1)
            make.bottom.equalTo(view).offset(-2.5)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        category.isUserInteractionEnabled = true
        category.addGestureRecognizer(tap)
    }
    
    @objc func onClick() {
        self.delegate?.onClick(cell: self, data: self.data)
    }
    
    func selectedItem(isActive: Bool) {
        self.category.backgroundColor = isActive ? ColorConfig().black : ColorConfig().white
        self.category.textColor = isActive ? ColorConfig().white : ColorConfig().black
//        self.layer.borderColor = isActive ? ColorConfig().black?.cgColor : ColorConfig().lightGray?.cgColor
    }
}
