//
//  WalletTransferDetailsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/29/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

struct WalletTransferData {
    var senderNum : String
    var senderName : String
    var recipientNum : String
    var recipientName : String
    var amount : String
}

class WalletTransferDetailsViewController: BaseHomeViewControler {
    
    var viewModel : LoadWalletViewModel?
    
    var data : WalletTransferData?
    
    lazy var headerView : CustomHeaderView = {
       let v = CustomHeaderView()
       return v
    }()
    
    lazy var senderLbl : UILabel = {
       let v = UILabel()
        v.text = "Sender"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var senderNum : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 16)
       v.numberOfLines = 0
       return v
    }()
    
    lazy var senderName : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var recipientLbl : UILabel = {
      let v = UILabel()
       v.text = "Recipient"
       v.font = UIFont(name: Fonts.regular, size: 12)
      return v
    }()

    lazy var recipientNum : UILabel = {
      let v = UILabel()
      v.font = UIFont(name: Fonts.bold, size: 16)
      v.numberOfLines = 0
      return v
    }()

    lazy var recipientName : UILabel = {
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
       v.font = UIFont(name: Fonts.medium, size: 16)
        v.text = "PHP 0.00"
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
    
     override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorConfig().bgColor
        setUpView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        hidesKeyboardOnTapArround()
        setUpData()
    }
    
    init(data: WalletTransferData?) {
        super.init(nibName: nil, bundle: nil)
        self.headerView.title.text = "Wallet transfer confirmation"
        self.headerView.desc.text = "Please ensure that the recipient and amount is correct"
        self.data = data
        
        //MARK: - set up values
        self.senderNum.text = "+63\(data?.senderNum ?? "")"
        self.senderName.text = data?.senderName
        self.recipientNum.text = "+63\(data?.recipientNum ?? "")"
        self.recipientName.text = data?.recipientName
        self.amount.text = "PHP \(data?.amount ?? "")"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpData() {
        self.viewModel?.onSuccessRequest = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.showAlert(buttonOK: "Ok", message: data?.title ?? "Something went wrong.", actionOk: { (action) in
                    self?.coordinator?.showParentView()
                }, completionHandler: nil)
            }
        }
       
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
            }
        }
   }
       
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(25)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(80)
        }

        view.addSubview(senderLbl)
        senderLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        view.addSubview(senderNum)
        senderNum.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(senderLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(senderName)
        senderName.snp.makeConstraints { (make) in
           make.top.equalTo(senderNum.snp.bottom)
           make.leading.equalTo(senderLbl.snp.trailing).offset(10)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(20)
        }
        
        view.addSubview(recipientLbl)
        recipientLbl.snp.makeConstraints { (make) in
            make.top.equalTo(senderLbl.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        view.addSubview(recipientNum)
        recipientNum.snp.makeConstraints { (make) in
            make.top.equalTo(senderName.snp.bottom).offset(10)
            make.leading.equalTo(recipientLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(recipientName)
        recipientName.snp.makeConstraints { (make) in
           make.top.equalTo(recipientNum.snp.bottom)
           make.leading.equalTo(recipientLbl.snp.trailing).offset(10)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(20)
        }
        

        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
            make.top.equalTo(recipientLbl.snp.bottom).offset(30)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(40)
        }

        view.addSubview(amount)
        amount.snp.makeConstraints { (make) in
            make.top.equalTo(recipientName.snp.bottom).offset(10)
            make.leading.equalTo(amountLbl.snp.trailing).offset(10)
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
        self.setAnimate(msg: "Please wait")
        self.viewModel?.sendMoney(amount: data?.amount ?? "" ,customerId: UserLoginData.shared.id ?? 0, phone: data?.recipientNum ?? "")
    }
        
}
