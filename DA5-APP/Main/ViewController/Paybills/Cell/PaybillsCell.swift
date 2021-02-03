//
//  PaybillsCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/28/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

protocol PaybillsCellDelegate : class {
    func onClick(cell: PaybillsCell, data: BillerData?)
}
class PaybillsCell : UICollectionViewCell {

    var section : Int? = nil // added for the key
    var index : Int = 0
    var delegate : PaybillsCellDelegate?
    
     var data : BillerData? {
        didSet {
//            self.imageView.tag = index
            self.imageView.downloaded(from: data?.logo ?? "", tag: index, contentMode: .scaleAspectFit)
            self.title.text = data?.name
            self.name.text = data?.type
            self.price.text = "Fee \(data?.fee ?? "0.00")"
            self.updateHeight()
        }
    }
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.image = nil
        return v
    }()
    
    lazy var title : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var name : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       v.textColor = ColorConfig().lightGray
        v.numberOfLines = 0
       return v
    }()
    
    lazy var price : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
        v.textAlignment = .right
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
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.leading.equalTo(self)
        }
        
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(self).multipliedBy(0.5)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        addSubview(price)
        price.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.height.equalTo(20)
            make.trailing.equalTo(self)
            make.leading.equalTo(name.snp.trailing).offset(10)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func updateHeight() {
        
        let height : CGFloat = data?.type.heightForView(font: name.font, width: (self.frame.width * 0.4 ) - 10) ?? 20
        
        name.snp.remakeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.height.equalTo(height < 20 ? 20 : 40 )
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
    }
    
    @objc func onClickAction(){
        self.delegate?.onClick(cell: self, data: self.data)
    }
}

