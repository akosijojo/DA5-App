//
//  PendingTransactionCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit
protocol PendingTransactionDelegate: class {
    func onClickItem(cell: PendingTransactionCell, index: Int?)
    func removeItem(cell: PendingTransactionCell, index: Int?)
}
class PendingTransactionCell: UICollectionViewCell {
    
    var data : PendingTransactionsData? {
        didSet {
            if let d = data {
                if let cashInOut = d.cashInOut {
    //                self.imageView.image = UIImage(named: d.cashInOut?.partnerImage)
                    self.imageView.image = UIImage(named: "western")
                    self.titleLbl.text = cashInOut.type == 0 ? "CASH IN" : "CASH OUT"
                    self.priceLbl.text = "PHP \(cashInOut.amount ?? "")"
                    self.dateLbl.text = cashInOut.transactionDate?.formatDate()
                    self.refNoLbl.text = "Ref No. \(cashInOut.referenceNo ?? "")"
                }
                
//                if let eLoad = d.eload {
//
//                }

//                if let walletTransfer = d.walletTransfer {
//
//                }

//                if let fx = d.fx {
//
//                }

//                if let instapay = d.instapay {
//
//                }
            }
        }
    }
    
    var delegate : PendingTransactionDelegate?
    
    var index : Int?
    
    lazy var mainView : UIView = {
       let v = UIView()
       v.layer.cornerRadius = 10
       return v
    }()
    
    lazy var containerView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    lazy var removeIcon : UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        v.setImage(UIImage(named: "times"), for: .normal)
        v.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        return v
    }()

    lazy var titleLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        return v
    }()
    
    lazy var priceLbl : UILabel = {
       let v = UILabel()
       v.text = "PHP 0.00"
       v.font = UIFont(name: Fonts.medium, size: 12)
       v.textColor = ColorConfig().lightBlue
       return v
    }()
    
    lazy var dateLbl : UILabel = {
      let v = UILabel()
      v.font = UIFont(name: Fonts.medium, size: 12)
      v.textColor = ColorConfig().lightBlue
      return v
    }()
    
    lazy var refNoLbl : UILabel = {
      let v = UILabel()
      v.font = UIFont(name: Fonts.medium, size: 12)
      return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = ColorConfig().white
        setUpView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        let rect = CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height - 5)
        self.layer.shadowPath = UIBezierPath(rect:rect).cgPath
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2
    }
    
    func setUpView() {
        addSubview(mainView)
        mainView.frame = bounds
        mainView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(mainView)
            make.leading.equalTo(mainView)
            make.trailing.equalTo(mainView)
            make.height.equalTo(mainView).multipliedBy(0.5)
        }
        
        mainView.addSubview(removeIcon)
        removeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(5)
            make.width.equalTo(20)
            make.trailing.equalTo(mainView).offset(-5)
            make.height.equalTo(20)
        }
        mainView.bringSubviewToFront(removeIcon)
        
        mainView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalTo(mainView).offset(15)
            make.trailing.equalTo(mainView).offset(-15)
            make.height.equalTo(mainView).multipliedBy(0.5)
        }
        
        containerView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(containerView).offset(5)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.height.equalTo(containerView).multipliedBy(0.2)
        }
        
        containerView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom)
            make.leading.equalTo(containerView)
            make.trailing.equalTo(containerView)
            make.height.equalTo(containerView).multipliedBy(0.2)
        }
        
        containerView.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { (make) in
           make.top.equalTo(priceLbl.snp.bottom)
           make.leading.equalTo(containerView)
           make.trailing.equalTo(containerView)
           make.height.equalTo(containerView).multipliedBy(0.2)
        }
        
        containerView.addSubview(refNoLbl)
        refNoLbl.snp.makeConstraints { (make) in
           make.top.equalTo(dateLbl.snp.bottom)
           make.leading.equalTo(containerView)
           make.trailing.equalTo(containerView)
           make.height.equalTo(containerView).multipliedBy(0.2)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tap)
        
        removeIcon.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        removeIcon.isUserInteractionEnabled = true
    }
    
    @objc func onClick() {
        print("CLICKING : \(index)")
        self.delegate?.onClickItem(cell: self, index: index)
    }
    
    @objc func removeItem() {
        print("REMOVING : \(index)")
        self.delegate?.removeItem(cell: self, index: index)
    }
}
