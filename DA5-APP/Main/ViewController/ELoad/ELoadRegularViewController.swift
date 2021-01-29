//
//  ELoadRegularViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/6/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ELoadRegularViewController: BaseHomeViewControler {
    
    var viewModel : ELoadViewModel?
    
    var data : ELoadProducts?
    
    var phone : String?
    
    lazy var headerView : CustomHeaderView2Desc = {
       let v = CustomHeaderView2Desc()
       return v
    }()
    
    lazy var amountInput : UITextField = {
        let v = UITextField()
        v.font = UIFont(name: Fonts.medium, size: 20)
        v.addBorders(edges: .bottom, color: ColorConfig().darkGray!)
        v.textAlignment = .center
        v.text = "PHP 0.00"
        v.keyboardType = .numberPad
        v.addTarget(self, action: #selector(amountEntered(_:)), for: .editingChanged)
        return v
    }()

    lazy var submitBtn : UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 5
        v.backgroundColor = ColorConfig().black
        v.setTitle("Proceed", for: .normal)
        v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)
        v.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        return v
    }()
    
    init(data: ELoadProducts?,phone: String?) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        self.headerView.title.text = data?.productCode
        self.headerView.desc1.text = "Please enter your preferred amount"
        
        self.phone = phone
        self.headerView.desc2.text = "+63\(phone ?? "")"
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
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(25)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(100)
        }

        view.addSubview(amountInput)
        amountInput.snp.makeConstraints { (make) in
          make.top.equalTo(headerView.snp.bottom).offset(80)
          make.leading.equalTo(view).offset(40)
          make.trailing.equalTo(view).offset(-40)
          make.height.equalTo(40)
        }

        amountInput.delegate = self

        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
          make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(40)
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
    
    @objc func onClick() {
        if let strAmount = self.amountInput.text , strAmount.returnAmount() > data?.maxAmount?.returnAmount() ?? 0 {
            self.showAlert(buttonOK: "Ok", message: "Please enter an amount with a maximum of PHP \(data?.maxAmount ?? "0")", actionOk: nil, completionHandler: nil)
        }else {
            data?.minAmount = self.amountInput.text?.returnDecimalAmount()
            self.coordinator?.ShowELoadProductDetailsViewController(data: data, phone: phone)
        }
    }
      
}

