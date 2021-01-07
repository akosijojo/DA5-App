//
//  ELoadProductDetailsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/6/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ELoadProductDetailsViewController: BaseHomeViewControler {
    
    var viewModel : ELoadViewModel?
    
    var data : ELoadProducts?
    
    var phone : String?
    
    lazy var headerView : CustomHeaderView = {
       let v = CustomHeaderView()
       return v
    }()
    
    lazy var productLbl : UILabel = {
       let v = UILabel()
        v.text = "Load Product"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var productName : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 16)
       v.numberOfLines = 0
       return v
    }()
    
    lazy var productCode : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var amountLbl : UILabel = {
       let v = UILabel()
        v.text = "Amount"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var amount : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
        v.text = "PHP 0.00"
       return v
    }()
    
    lazy var numberLbl : UILabel = {
       let v = UILabel()
        v.text = "Phone Number"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var number : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 16)
        v.text = "+63"
       return v
    }()
  
    lazy var cancelBtn : UIButton = {
         let v = UIButton()
         v.layer.cornerRadius = 5
         v.backgroundColor = ColorConfig().black
         v.setTitle("Cancel", for: .normal)
         v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
         v.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside)
         return v
    }()
    
    lazy var submitBtn : UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().black
        v.setTitle("Confirm", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
        v.addTarget(self, action: #selector(onClickSubmit), for: .touchUpInside)
        return v
    }()
    
    init(data: ELoadProducts?,phone: String?) {
        super.init(nibName: nil, bundle: nil)
        self.headerView.title.text = "Buy load confirmation"
        self.headerView.desc.text = "Please ensure that the mobile number is correct"
        self.data = data
        self.phone = phone
        
        //MARK: - set up values
        self.productName.text = data?.productName
        self.productCode.text = "\(data?.network ?? "") \(data?.productCode ?? "")"
        self.number.text = "+63\(phone ?? "")"
        self.amount.text = data?.minAmount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(25)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(80)
        }

        view.addSubview(productLbl)
        productLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }

        let width : CGFloat = (view.frame.width * 0.3 + 50) - view.frame.width
        let height : CGFloat = data?.productName?.heightForView(font: productName.font, width: width) ?? 20
        
        view.addSubview(productName)
        productName.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(productLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(height > 20 ? height : 20)
        }
        
        print("HEEEE \(width) \(height)  === \(view.frame.width)")
        
        view.addSubview(productCode)
        productCode.snp.makeConstraints { (make) in
            make.top.equalTo(productName.snp.bottom)
            make.leading.equalTo(productLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
            make.top.equalTo(productLbl.snp.bottom).offset(height)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(40)
        }

        view.addSubview(amount)
        amount.snp.makeConstraints { (make) in
            make.top.equalTo(productCode.snp.bottom).offset(0)
            make.leading.equalTo(amountLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(numberLbl)
        numberLbl.snp.makeConstraints { (make) in
            make.top.equalTo(amountLbl.snp.bottom).offset(0)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(40)
        }

        view.addSubview(number)
        number.snp.makeConstraints { (make) in
            make.top.equalTo(amount.snp.bottom).offset(0)
            make.leading.equalTo(numberLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.4)
            make.height.equalTo(40)
        }

        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo(view).multipliedBy(0.4)
            make.height.equalTo(40)
        }
    }
    
    @objc func onClickCancel() {
        navBackAction()
    }
    
    @objc func onClickSubmit() {
        print("Submitting")
    }
        
}
