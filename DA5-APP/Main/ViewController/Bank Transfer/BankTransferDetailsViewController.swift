//
//  BankTransferDetailsViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/14/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class BankTransferDetailsViewController : BaseHomeViewControler {
    var viewModel : BankTransferViewModel?
    
    var data : TransferDetails?
    
    var phone : String?
    
    lazy var headerView : CustomHeaderView = {
       let v = CustomHeaderView()
        v.desc.numberOfLines = 0
        v.desc.textAlignment = .center
       return v
    }()
    
    lazy var bankLbl : UILabel = {
       let v = UILabel()
        v.text = "Bank Name"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var bankName : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.bold, size: 16)
       v.text = ""
        v.numberOfLines = 0
       return v
    }()
    
    lazy var accountLbl : UILabel = {
       let v = UILabel()
        v.text = "Account Name"
        v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var accountName : UILabel = {
      let v = UILabel()
       v.text = ""
       v.font = UIFont(name: Fonts.regular, size: 16)
      return v
    }()
    
    lazy var accountNumberLbl : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 12)
        v.text = "Account Number"
       return v
    }()
    
    lazy var accountNumber : UILabel = {
      let v = UILabel()
      v.font = UIFont(name: Fonts.regular, size: 16)
       v.text = ""
      return v
    }()
    
    lazy var transactionLbl : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 12)
         v.text = "Transaction fee"
        return v
     }()
     
     lazy var transactionFee : UILabel = {
       let v = UILabel()
       v.font = UIFont(name: Fonts.regular, size: 16)
        v.text = ""
       return v
     }()

    lazy var amountInput : UITextField = {
       let v = UITextField()
       v.font = UIFont(name: Fonts.medium, size: 20)
       v.addBorders(edges: .bottom, color: ColorConfig().darkGray!)
       v.textAlignment = .center
       v.text = "PHP 0.00"
       v.addTarget(self, action: #selector(amountEntered(_:)), for: .editingChanged)
       v.keyboardType = .numberPad
       return v
    }()

    lazy var amountLbl : UILabel = {
       let v = UILabel()
        v.text = "Enter desired amount"
        v.font = UIFont(name: Fonts.regular, size: 12)
        v.textAlignment = .center
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
    
    init(data: TransferDetails?) {
        super.init(nibName: nil, bundle: nil)
        self.headerView.title.text = "Bank Transfer"
        self.headerView.desc.text = "Please verify and the accuracy and completeness of the details before you proceed"
        self.data = data
//        self.phone = phone
//        
//        //MARK: - set up values
        self.bankName.text = data?.bank?.bank ?? ""
        self.accountName.text = data?.accountName ?? ""
        self.accountNumber.text = data?.accountNumber ?? ""
        self.transactionFee.text = "\(data?.transactionFee ?? "") PHP"
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
            self?.showAlert(buttonOK: "Ok", message:  data?.message ?? "Something went wrong", actionOk: { (action) in
                var bankLocal = BankLocalData(data: [BankAccountLocalData(accountNumber: self?.data?.accountNumber, accountName: self?.data?.accountName, code: self?.data?.bank?.code, bank: self?.data?.bank?.bank, brstn: self?.data?.bank?.brstn)])
                bankLocal.saveToLocal()
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

        view.addSubview(bankLbl)
        bankLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        let width : CGFloat = (view.frame.width * 0.3 + 50) - view.frame.width
        let height : CGFloat = data?.bank?.bank?.heightForView(font: bankName.font, width: width) ?? 20
        
        view.addSubview(bankName)
        bankName.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80)
            make.leading.equalTo(bankLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(height > 20 ? height : 20)
        }
        
        view.addSubview(accountLbl)
        accountLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(80 + height + 10)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        view.addSubview(accountName)
        accountName.snp.makeConstraints { (make) in
            make.top.equalTo(bankName.snp.bottom).offset(10)
            make.leading.equalTo(accountLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(accountNumberLbl)
        accountNumberLbl.snp.makeConstraints { (make) in
            make.top.equalTo(accountLbl.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(20)
        }
        
        view.addSubview(accountNumber)
        accountNumber.snp.makeConstraints { (make) in
            make.top.equalTo(accountName.snp.bottom).offset(10)
            make.leading.equalTo(accountNumberLbl.snp.trailing).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
        }
        
        view.addSubview(transactionLbl)
        transactionLbl.snp.makeConstraints { (make) in
           make.top.equalTo(accountNumber.snp.bottom).offset(10)
           make.leading.equalTo(view).offset(20)
           make.width.equalTo(view).multipliedBy(0.3)
           make.height.equalTo(20)
        }

        view.addSubview(transactionFee)
        transactionFee.snp.makeConstraints { (make) in
           make.top.equalTo(accountNumber.snp.bottom).offset(10)
           make.leading.equalTo(accountNumberLbl.snp.trailing).offset(10)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(20)
        }
        
        view.addSubview(amountInput)
        amountInput.snp.makeConstraints { (make) in
           make.top.equalTo(transactionLbl.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(40)
            make.trailing.equalTo(view).offset(-40)
            make.height.equalTo(40)
        }

        amountInput.delegate = self

        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
            make.top.equalTo(amountInput.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(20)
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
        if let amount = self.amountInput.text{
            let amountValue = amount.returnDoubletoStrings(wDecimal: true, wSeparator: false)
            if amountValue.returnDouble() > 0 {
                self.data?.amount = amountValue
                self.setAnimate(msg: "Please wait...")
                self.viewModel?.submitBankTransfer(data: data,token: self.coordinator?.token)
            }else {
                return
            }
        }
      
    }
        
    @objc func amountEntered(_ textField: UITextField) {
        if let amountString = amountInput.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func didEndEnteredAmount(_ textField: UITextField){
        if let amountString = amountInput.text?.returnDecimalAmount() {
            textField.text = amountString
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "PHP 0.00" {
            amountInput.text = "PHP "
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 21
    }
}
