//
//  WalletTransferViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/10/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class WalletTransferViewController: BaseHomeViewControler {
    
    var data : WalletTransferData?
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Send Money"
        v.desc.text = "Enter recipient's phone number and amount"
        return v
    }()
    
    lazy var phoneLbl : UILabel = {
       let v = UILabel()
       v.text = "Recipient's phone number"
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .numberPad
       v.FieldView.TextField.tag = 1
       v.FieldView.TextField.delegate = self
        v.FieldView.TextField.placeholder = "Phone Number"
       return v
    }()
    
    lazy var amountLbl : UILabel = {
       let v = UILabel()
       v.text = "Amount"
       v.font = UIFont(name: Fonts.regular, size: 12)
       return v
    }()
    
    lazy var amount: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .decimalPad
       v.FieldView.TextField.tag = 2
       v.FieldView.TextField.delegate = self
       v.FieldView.Label.text = "PHP"
       v.FieldView.TextField.placeholder = "Amount"
       v.FieldView.TextField.addTarget(self, action: #selector(amountChanged), for: .editingDidEnd)
       return v
    }()

    lazy var submitBtn : UIButton = {
      let v = UIButton()
       v.layer.cornerRadius = 5
       v.backgroundColor = ColorConfig().black
       v.setTitle("Proceed", for: .normal)
       v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
       v.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
      return v
    }()
    
    var viewModel : LoadWalletViewModel?
    
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
        // add request return
        self.viewModel?.onSuccessWalletDetailsData = { [weak self] data in
            DispatchQueue.main.async {
                 print("GOTO WALLET TRANSFER DETAILS ")
                self?.data?.recipientName = "\(data?.firstName ?? "") \(data?.lastName ?? "")"
                  self?.coordinator?.showWalletTransferDetailsViewController(data:  self?.data)
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self] status in
            DispatchQueue.main.async {
                self?.showAlert(buttonOK: "Ok", message: status?.message ?? "Something went wrong.", actionOk: nil, completionHandler: nil)
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
        
        view.addSubview(phoneLbl)
        phoneLbl.snp.makeConstraints { (make) in
          make.top.equalTo(headerView).offset(100)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(20)
        }
        
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLbl.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
        }
        
        view.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
          make.top.equalTo(phoneNumber.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(20)
        }
        
        view.addSubview(amount)
        amount.snp.makeConstraints { (make) in
          make.top.equalTo(amountLbl.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
        }
        amount.FieldView.TextField.delegate = self
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }

         changeView()
    }
    
    @objc func amountChanged(_ textField: UITextField) {
        if let amountString = amount.FieldView.TextField.text?.amountEntered() {
           textField.text = amountString
        }
    }
    
    func changeView(){
        self.phoneNumber.removeLblHeight()
        self.amount.removeLblHeight()
        self.amount.FieldView.removeBorder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            textField.text = textField.text?.replacingOccurrences(of: ",", with: "")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("CHANGING INPUT")
         guard let text = textField.text else { return true }
         if textField.tag == 1 {
            let count = text.count + string.count - range.length
            return count <= 10
         } else if textField.tag == 2 {
            return self.amountFormating(textField: textField, string: string)
         }else {
            return true
         }
    }
    
    //MARK:- RESTRICTIONS
    func amountFormating(textField: UITextField,string: String) -> Bool{
        switch string {
         case "0","1","2","3","4","5","6","7","8","9":
             if (textField.text?.first == "0") {
               return false
             }
             return true
         case ".":
           var decimalCount : Int = 0
           let array = Array(arrayLiteral: textField.text)
             for character in array {
               print("CHANGING INPUT HEREEEE ARRAY = \(array.count) == \(character)" )
               if character?.contains(".") ??  false{
                   print("CHANGING INPUT HEREEEE ARRAY INPUT . = \(decimalCount)" )
                     decimalCount += 1
                 }
             }
             print("CHANGING INPUT HEREEEE = \(decimalCount)" )

             if decimalCount >= 1 {
                 return false
             } else {
                 return true
             }
         default:
             let array = Array(string)
             if array.count == 0 {
                 return true
             }
             return false
         }
    }
    
    @objc func submitAction() {
        if let number = self.phoneNumber.FieldView.TextField.text, let amount = self.amount.FieldView.TextField.text , number != "" && amount.returnAmount() >= 1{

            self.data = WalletTransferData(senderNum: UserLoginData.shared.phoneNumber ?? "", senderName: "\(UserLoginData.shared.firstName ?? "") \(UserLoginData.shared.lastName ?? "")", recipientNum: number, recipientName: "", amount: amount)
            
            self.viewModel?.sendMoneyDetails(amount:"\(amount.returnAmount())", customerId: UserLoginData.shared.id ?? 0, phone: number)
            
        }else {
            let phone = self.phoneNumber.FieldView.TextField.text
            self.showAlert(buttonOK: "Ok", message: phone == "" ? "Phone number is invalid." : "Please enter your desired amount for trasfer.", actionOk: nil, completionHandler: nil)
        }
       
    }
    
}
