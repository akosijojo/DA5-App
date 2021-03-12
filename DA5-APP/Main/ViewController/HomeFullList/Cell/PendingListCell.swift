//
//  PendingListCell.swift
//  DA5-APP
//
//  Created by Jojo on 1/25/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BottomLoaderCell: UICollectionViewCell {
    var refreshControl = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(refreshControl)
        refreshControl.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        refreshControl.startAnimating()
    }
}


protocol PendingListCellDelegate : class {
    func onClick(cell:PendingListCell, data: PendingTransactionsData?)
}

class PendingListCell: UICollectionViewCell {
    
    var index : Int = 0
    var delegate : PendingListCellDelegate?
    
     var data : PendingTransactionsData? {
        didSet {
            if let d = data {
                if let cashInOut = d.cashInOut {
    //                self.imageView.image = UIImage(named: d.cashInOut?.partnerImage)
//                    self.imageView.downloaded(from: cashInOut.partnerImage ?? "",contentMode: .scaleAspectFit)
                    self.imageView.image = cashInOut.type == 0 ? UIImage(named: "cashIn") : UIImage(named: "cashOut")
                    self.title.text = cashInOut.type == 0 ? "CASH IN" : "CASH OUT"
                    self.name.text = cashInOut.partnerName
                    self.price.text = "PHP \(cashInOut.amount ?? "")"
                    self.date.text = cashInOut.transactionDate?.formatDate()
                    self.referenceNo.text = "Ref No. \(cashInOut.referenceNo ?? "")"
                }

                if let eLoad = d.eload {
//                    self.imageView.downloaded(from: eLoad. .partnerImage ?? "",contentMode: .scaleAspectFill)
                    self.imageView.image = UIImage(named: "app_logo")
                    self.name.text = eLoad.productName
                    self.title.text = "\(eLoad.productNetwork ?? "") \(eLoad.productName)"
                    self.price.text = "PHP \(eLoad.productAmount ?? "")"
                    self.date.text = eLoad.transactionDate?.formatDate()
                    self.referenceNo.text = "Ref No. \(eLoad.referenceNo ?? "")"
                }

//                if let walletTransfer = d.walletTransfer {
//
//                }

                if let fx = d.fx {
                    self.imageView.image = UIImage(named: "app_logo")
                    self.name.text = fx.customerName
                    self.title.text = "FX Trade"
                    self.price.text = "\(fx.convertedAmount ?? "") \(fx.currency ?? "")"
                    self.date.text = fx.transactionDate?.formatDate()
                    self.referenceNo.text = "Ref No. \(fx.referenceNo ?? "")"
                }

                if let instapay = d.instapay {
                    self.imageView.image = UIImage(named: "app_logo")
                    self.name.text = instapay.bankName
                    self.title.text = "\(instapay.bankName ?? "")"
                    self.price.text = "PHP \(instapay.amount ?? "")"
                    self.date.text = instapay.tranRequestDate?.formatDate()
                    self.referenceNo.text = "Ref No. \(instapay.referenceNo ?? "")"
                }
            }
        }
    }
        
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = ColorConfig().whiteGray?.cgColor
        return v
    }()
    
    lazy var title : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       v.textColor = ColorConfig().lightGray
       return v
    }()
    
    lazy var name : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var referenceNo : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var date : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       v.textColor = ColorConfig().lightGray
       v.textAlignment = .right
       return v
    }()
    
    lazy var price : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       v.textColor = ColorConfig().lightBlue
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.cornerRadius = 10
//        let rect = CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height - 5)
//        self.layer.shadowPath = UIBezierPath(rect:rect).cgPath
//        self.layer.shadowRadius = 4
//        self.layer.shadowOffset = .zero
//        self.layer.shadowOpacity = 0.2
//    }
       
    func setUpView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.leading.equalTo(self).offset(20)
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
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        addSubview(referenceNo)
        referenceNo.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(self).multipliedBy(0.4)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
//
        addSubview(date)
        date.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
            make.trailing.equalTo(self).offset(-20)
            make.leading.equalTo(title.snp.trailing).offset(10)
        }
        
        addSubview(price)
        price.snp.makeConstraints { (make) in
            make.top.equalTo(date.snp.bottom)
            make.height.equalTo(20)
            make.trailing.equalTo(self).offset(-20)
            make.leading.equalTo(name.snp.trailing).offset(10)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc func onClickAction(){
        self.delegate?.onClick(cell: self, data: self.data)
    }
}
