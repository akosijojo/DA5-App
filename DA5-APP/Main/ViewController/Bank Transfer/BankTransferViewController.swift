//
//  BankTransferViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/11/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankTransferViewController: BaseHomeViewControler {
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Bank transfer"
        v.desc.text = "Transfer to?"
        return v
    }()
    
    lazy var bankList: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.delegate = self
        v.TextField.placeholder = "Select Bank*"
        v.TextField.tag = 1
        v.TextField.isUserInteractionEnabled = true
        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    lazy var accountNumber: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .numberPad
        v.TextField.tag = 2
        v.TextField.placeholder = "Account Number"
        v.TextField.delegate = self
        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    lazy var accountName: CustomBasicFormInput = {
        let v = CustomBasicFormInput()
        v.TextField.keyboardType = .default
        v.TextField.tag = 3
        v.TextField.placeholder = "Account Name"
        v.TextField.delegate = self
         v.TextField.font = UIFont(name: Fonts.regular, size: 12)
        return v
    }()
    
    
//    lazy var emailInfo: UILabel = {
//       let v = UILabel()
//       v.text = "To notify the recipient, please enter their email to send the receipt."
//       v.font = UIFont(name: Fonts.regular, size: 12)
//       v.numberOfLines = 2
//       return v
//    }()
//
//    lazy var emailAddress: CustomBasicFormInput = {
//        let v = CustomBasicFormInput()
//        v.TextField.keyboardType = .emailAddress
//        v.TextField.tag = 4
//        v.TextField.placeholder = "Email Address"
//        v.TextField.delegate = self
//        v.TextField.font = UIFont(name: Fonts.regular, size: 12)
//        return v
//    }()
    
    lazy var bankTransferInfo: UILabel = {
       let v = UILabel()
       v.text = "+ Php 50,000.00 daily transaction limit per source \n + Php 25.00 bank transfer fee per transaction"
       v.numberOfLines = 2
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()

    lazy var submitBtn : UIButton = {
      let v = UIButton()
       v.layer.cornerRadius = 5
       v.backgroundColor = ColorConfig().black
       v.setTitle("Next", for: .normal)
       v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
       v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
      return v
    }()
    
    var viewModel : BankTransferViewModel?
    
    var banksListData : BankListDataCollection?
    
    var bankSelected : BankListData? {
        didSet {
            self.bankList.TextField.text = bankSelected?.bank ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesKeyboardOnTapArround()
        setUpView()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    override func setUpData() {
        self.viewModel?.onSuccessBankListData = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.banksListData = data
            }
        }
        
        self.viewModel?.onSuccessRequest = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                
            }
        }
       
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong", actionOk: nil, completionHandler: nil)
            }
        }
        
        self.setAnimate(msg: "Please wait...")
        self.viewModel?.getBankList(token: self.coordinator?.token)
    }
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(view).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(80)
        }
        
        view.addSubview(bankList)
        bankList.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(20)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
        }
        
        view.addSubview(accountNumber)
        accountNumber.snp.makeConstraints { (make) in
            make.top.equalTo(bankList.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(accountName)
        accountName.snp.makeConstraints { (make) in
            make.top.equalTo(accountNumber.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
//        view.addSubview(emailInfo)
//        emailInfo.snp.makeConstraints { (make) in
//            make.top.equalTo(accountName.snp.bottom).offset(20)
//            make.leading.equalTo(view).offset(20)
//            make.trailing.equalTo(view).offset(-20)
//            make.height.equalTo(40)
//        }
//
//        view.addSubview(emailAddress)
//        emailAddress.snp.makeConstraints { (make) in
//            make.top.equalTo(emailInfo.snp.bottom).offset(10)
//            make.leading.equalTo(view).offset(20)
//            make.trailing.equalTo(view).offset(-20)
//            make.height.equalTo(40)
//        }
//
        view.addSubview(bankTransferInfo)
        bankTransferInfo.snp.makeConstraints { (make) in
//            make.top.equalTo(emailAddress.snp.bottom).offset(10)
            make.top.equalTo(accountName.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        
        bankList.removeLblHeight()
        accountNumber.removeLblHeight()
        accountName.removeLblHeight()
//        emailAddress.removeLblHeight()

        let showBank = UITapGestureRecognizer(target: self, action: #selector(showBankList))
        bankList.TextField.addGestureRecognizer(showBank)
    }
    
    @objc func submitAction() {
        if let bank = self.bankList.TextField.text , let account = self.accountName.TextField.text, let accountNum = self.accountNumber.TextField.text, bank != "" && account != "" && accountNum != "" {
            
            self.coordinator?.showBankTransferDetailsViewController(data: TransferDetails(bank: self.bankSelected, accountName: account, accountNumber: accountNum, transactionFee: "25", amount: nil))
        }else {
            self.showAlert(buttonOK: "Ok", message: "Please fill out the following required fields to proceed.", actionOk: nil, completionHandler: nil)
        }
      
    }
    
    @objc func showBankList() {
       let vc = BankDropListViewController()
       vc.modalPresentationStyle = .overCurrentContext
       vc.parentView = self
       vc.data = self.banksListData?.collection
       self.present(vc, animated: false) {
            vc.showModal()
       }
    }
    
}
