//
//  TransactionHistoryCell.swift
//  DA5-APP
//
//  Created by Jojo on 11/23/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

protocol TransactionHistoryDelegate: class {
    func onClickItem(cell: TransactionHistoryCell, index: Int?)
}

class TransactionHistoryCell: UICollectionViewCell {
    
    var data : TransactionHistoryData? {
        didSet {
             if let d = data {
                if let cashInOut = d.cashInOut {
                    let titleText = NSMutableAttributedString(string: cashInOut.type == 0 ? "CASH IN" : "CASH OUT", attributes: nil)
                    let statusText = NSAttributedString(string: cashInOut.status == 2 ? " (Rejected)" : " (Accepted)", attributes: [NSAttributedString.Key.foregroundColor: ColorConfig().red!])
                    titleText.append(statusText)
                    
                    self.titleLbl.attributedText = titleText
                    self.nameLbl.text = cashInOut.partnerName
                    self.descLbl.text = "Ref No. \(d.referenceNo ?? "")"
                    self.priceLbl.text = "PHP \(cashInOut.amount ?? "")"
                    self.timeLbl.text = cashInOut.transactionDate?.formatDate(format: "HH:mm:ss a")
                    self.dateLbl.text = cashInOut.transactionDate?.formatDate()
                }
                
                if let eLoad = d.eload {
                    self.titleLbl.text = "ELoad"
                    self.nameLbl.text = eLoad.productName
                    self.descLbl.text = "Ref No. \(eLoad.referenceNo ?? "")"
                    self.priceLbl.text = "PHP \(eLoad.productAmount ?? "")"
                    self.timeLbl.text = eLoad.transactionDate?.formatDate(format: "hh:mm:ss a")
                    self.dateLbl.text = eLoad.transactionDate?.formatDate()
                }

                if let walletTransfer = d.walletTransfer {
                    self.titleLbl.text = "Wallet Transfer"
                    self.nameLbl.text =  walletTransfer.customerName
                    self.descLbl.text = "+63\(walletTransfer.recipientPhone ?? "")"
                    self.bankLbl.text = "Ref No. \(walletTransfer.referenceNo ?? "")"
                    self.bankFee.text = ""
                    self.priceLbl.text = "PHP \(walletTransfer.amount ?? "")"
                    self.timeLbl.text = walletTransfer.transactionDate?.formatDate(format: "hh:mm:ss a")
                    self.dateLbl.text = walletTransfer.transactionDate?.formatDate()
                }

                if let fx = d.fx {
                    let titleText = NSMutableAttributedString(string: "FX Trade", attributes: nil)
                    let statusText = NSAttributedString(string: fx.status == 2 ? " (Rejected)" : " (Accepted)", attributes: [NSAttributedString.Key.foregroundColor: ColorConfig().red!])
                    titleText.append(statusText)
                    self.titleLbl.attributedText = titleText
                    self.nameLbl.text = fx.customerName
                    self.descLbl.text = "Ref No. \(fx.referenceNo ?? "")"
                    self.priceLbl.text = "\(fx.convertedAmount ?? "") \(fx.currency ?? "")"
                    self.timeLbl.text = fx.transactionDate?.formatDate(format: "hh:mm:ss a")
                    self.dateLbl.text = fx.transactionDate?.formatDate()
                }

                if let instapay = d.instapay {
                    self.titleLbl.text = "Bank Transfer"
                    self.nameLbl.text = instapay.bankName
                    self.descLbl.text = "Ref No. \(instapay.referenceNo ?? "")"
                    self.priceLbl.text = "PHP \(instapay.amount ?? "")"
                    self.timeLbl.text = instapay.tranRequestDate?.formatDate(format: "hh:mm:ss a")
                    self.dateLbl.text = instapay.tranRequestDate?.formatDate()
                }
            }
            //MARK: - Check if instapay or wallet transfer
            self.setUpBankFee(show: self.data?.instapay != nil || self.data?.walletTransfer != nil ? true : false)
        }
    }
    
    var delegate : TransactionHistoryDelegate?
    
    var index : Int?
    
    lazy var titleLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.textColor = ColorConfig().gray
        return v
    }()
    
    lazy var nameLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        return v
    }()
    
    lazy var descLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.medium, size: 12)
        return v
    }()
    
    lazy var bankLbl : UILabel = {
        let v = UILabel()
        v.text = "Bank Convenience Fee"
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
    
    lazy var timeLbl : UILabel = {
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
    
    lazy var bankFee : UILabel = {
         let v = UILabel()
         v.font = UIFont(name: Fonts.medium, size: 12)
         v.text = "PHP 25.00"
         v.textAlignment = .right
         v.textColor = ColorConfig().red
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
        
        addSubview(nameLbl)
        nameLbl.snp.makeConstraints { (make) in
           make.top.equalTo(titleLbl.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.width.equalTo(self).multipliedBy(0.6)
           make.height.equalTo(20)
        }
        
        addSubview(descLbl)
        descLbl.snp.makeConstraints { (make) in
           make.top.equalTo(nameLbl.snp.bottom)
           make.leading.equalTo(self).offset(10)
           make.width.equalTo(self).multipliedBy(0.6)
           make.height.equalTo(20)
        }
        
        addSubview(bankLbl)
        bankLbl.snp.makeConstraints { (make) in
          make.top.equalTo(descLbl.snp.bottom)
          make.leading.equalTo(self).offset(10)
          make.width.equalTo(self).multipliedBy(0.6)
          make.height.equalTo(0)
        }
        
        addSubview(dateLbl)
        dateLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.width.equalTo(self).multipliedBy(0.4)
            make.height.equalTo(20)
        }
        
        addSubview(timeLbl)
        timeLbl.snp.makeConstraints { (make) in
           make.top.equalTo(dateLbl.snp.bottom)
           make.trailing.equalTo(self).offset(-10)
           make.width.equalTo(self).multipliedBy(0.4)
           make.height.equalTo(20)
        }
        
        addSubview(priceLbl)
        priceLbl.snp.makeConstraints { (make) in
           make.top.equalTo(timeLbl.snp.bottom)
            make.trailing.equalTo(self).offset(-10)
           make.width.equalTo(self).multipliedBy(0.4)
           make.height.equalTo(20)
        }
        
        addSubview(bankFee)
        bankFee.snp.makeConstraints { (make) in
           make.top.equalTo(priceLbl.snp.bottom)
           make.trailing.equalTo(self).offset(-10)
           make.width.equalTo(self).multipliedBy(0.4)
           make.height.equalTo(0)
        }
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(bankLbl.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
    }
    
    @objc func onClick() {
        print("CLICKING : \(index)")
        self.delegate?.onClickItem(cell: self, index: index)
    }
    
    func setUpBankFee(show: Bool) {
            bankLbl.isHidden = show ? false : true
            bankFee.isHidden = show ? false : true
            bankLbl.snp.updateConstraints { (make) in
                make.height.equalTo(show ? 20 : 0)
            }
            bankFee.snp.updateConstraints { (make) in
                make.height.equalTo(show ? 20 : 0)
            }
    }
}
