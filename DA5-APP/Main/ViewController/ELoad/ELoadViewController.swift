//
//  ELoadViewController.swift
//  DA5-APP
//
//  Created by Jojo on 1/5/21.
//  Copyright © 2021 OA. All rights reserved.
//

import UIKit

class ELoadViewController: BaseHomeViewControler {
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.title.text = "Buy Load"
        v.desc.text = "Enter phone number to reload"
        return v
    }()
    
    lazy var phoneNumber: CustomBasicFormInputNumber = {
       let v = CustomBasicFormInputNumber()
       v.FieldView.TextField.keyboardType = .numberPad
       v.FieldView.TextField.tag = 1
       v.FieldView.TextField.delegate = self
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
    
    var viewModel : ELoadViewModel?
    
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
        self.viewModel?.onSuccessDataRequest = { [weak self] data in
            DispatchQueue.main.async {
                self?.stopAnimating()
                self?.coordinator?.ShowELoadProductsViewController(data: data?.collection?.data ?? [],phone: self?.phoneNumber.FieldView.TextField.text)
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
    }
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
           make.top.equalTo(view).offset(25)
           make.leading.equalTo(view).offset(20)
           make.trailing.equalTo(view).offset(-20)
           make.height.equalTo(80)
        }
        
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints { (make) in
          make.top.equalTo(headerView).offset(100)
          make.leading.equalTo(view).offset(20)
          make.trailing.equalTo(view).offset(-20)
          make.height.equalTo(70)
        }
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         if textField.tag == 1 {
            let count = text.count + string.count - range.length
            return count <= 10
         }
        return true
    }
    
    @objc func submitAction() {
        if let number = self.phoneNumber.FieldView.TextField.text , number != ""{
             self.setAnimate(msg: "Please wait")
             self.viewModel?.getELoadProducts(phoneNumber: number)
        }else {
            self.showAlert(buttonOK: "Ok", message: "Phone number is invalid.", actionOk: nil, completionHandler: nil)
        }
       
    }
    
}
