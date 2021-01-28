//
//  PinViewController.swift
//  DA5-APP
//
//  Created by Jojo on 11/19/20.
//  Copyright © 2020 OA. All rights reserved.
//

import UIKit

class PinViewController: BaseViewControler {
    //MARK: - CHECKING IF FROM INACTIVE STATE
    var fromBackground: Bool = false

    var timer : Timer?
    var seconds : Int = 0
    var maxPIN : Int = 4
    var isChecking : Bool? = false
    var MPIN : String? = ""
    var clearedPin : Bool = false
    var tokenData : APIToken?
    
    var viewModel: LoginViewModel?
    
    var customerData : Customer? {
        didSet {
            print("ALREADY SAVE TO LOCAL FROM COORDINATOR")
        }
    }
    
    lazy var topView : UIView = {
       let v = UIView()
       return v
    }()
    lazy var imgLogo : UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: "app_logo")
       return v
    }()
    
    lazy var mainLabel : UILabel = {
       let v = UILabel()
        v.text = "ENTER YOUR MPIN"
        v.font = UIFont(name: Fonts.bold, size: 25)
        v.textAlignment = .center
       return v
    }()
    
    lazy var secondaryLabel : UILabel = {
       let v = UILabel()
       v.text = "Never share your MPIN with anyone."
       v.font = UIFont(name: Fonts.medium, size: 12)
       v.textAlignment = .center
       return v
    }()
    
    lazy var pinTextField : CustomPinTextField = {
       let v = CustomPinTextField()
       return v
    }()
    
    lazy var pinTextFieldError : UILabel = {
       let v = UILabel()
        v.textColor = ColorConfig().darkRed
        v.textAlignment = .center
        v.text = "Incorrect MPIN"
        v.font = UIFont(name: Fonts.medium, size: 12)
        v.isHidden = true
       return v
    }()
    
    lazy var bottomView : UIView = {
       let v = UIView()
       return v
    }()
    
    lazy var forgotMpin : UIButton = {
        let v = UIButton(type: .system)
        v.titleLabel?.font = UIFont(name: Fonts.medium, size: 12)!
        v.setTitle("Forgot MPIN?", for: .normal)
        v.addTarget(self, action: #selector(forgotMpinClick), for: .touchUpInside)
       return v
    }()
    
    lazy var numPadView : CustomNumPad = {
       let v = CustomNumPad()
        v.btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
       return v
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func getData() {
       pinTextField.defaultText = "•"
       pinTextField.configure(with: maxPIN)
       numPadView.maxInput =  maxPIN
       pinTextField.didEnterFirstDigit = { [weak self] code in
            if self?.pinTextFieldError.isHidden == false {
                self?.pinTextFieldError.isHidden = true
            }
       }
        
       pinTextField.didEnterLastDigit = { [weak self] code in
            self?.checkMPIN(pin: code)
//           self?.MPIN = code
           //  checking of pin then goto home
//           self?.coordinator?.homeCoordinator()
       }
        
       numPadView.numPadReturnOutput = { [weak self] output in
           self?.pinTextField.textUpdate(text: output)
       }
       
       if isChecking ?? false {
            self.viewModel?.onSuccessGettingList = { [weak self] res in
                  DispatchQueue.main.async {
                      self?.stopAnimating()
                      //MARK: - UPDATE LOCAL DATA
                      let updateLocal = res?.convertToLocalData()
                      updateLocal?.saveCustomerToLocal()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self?.coordinator?.homeCoordinator()
                        }
                  }
             }
             self.viewModel?.onSuccessGenerateToken = {[weak self] data in
                 DispatchQueue.main.async {
                     self?.tokenData = data
                 }
             }
       }
    
       self.viewModel?.onSuccessRequest = { [weak self] res in
            DispatchQueue.main.async {
                self?.stopAnimating()
            }
       }
        
       self.viewModel?.onErrorHandling = { [weak self] res in
             DispatchQueue.main.async {
                self?.stopAnimating()
            }
       }
        
    
        //MARK:- Get API TOKEN
        print("------- \n PIN VIEW \(isChecking) \n ------------")
        if let noMPIN = isChecking , noMPIN == true {
            //REMOVE FORGOT MPIN BUTTON 
            self.forgotMpin.isHidden = true
            //MARK: - INFO : CHECKING IF HAVE TOKEN = && self.coordinator?.token == nil
            // also add saving token in coordinator : self.coordinator.token = token get prome request
            // and change token send to : self.coordinator.token
            print("GET API TOKEN")
            self.viewModel?.generateAPIToken()
        }
    }
    
    override func setUpView() {
        view.addSubview(topView)
        topView.addSubview(imgLogo)
        topView.addSubview(mainLabel)
        topView.addSubview(secondaryLabel)
        topView.addSubview(pinTextField)
        topView.addSubview(pinTextFieldError)
        view.addSubview(bottomView)
        bottomView.addSubview(numPadView)
        bottomView.addSubview(forgotMpin)
    
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(view.layoutMarginsGuide).multipliedBy(0.50)
        }
        imgLogo.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView).offset(-40)
            make.centerX.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        mainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgLogo.snp.bottom).offset(20)
            make.leading.equalTo(topView).offset(20)
            make.trailing.equalTo(topView).offset(-20)
            make.height.equalTo(20)
        }
        secondaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
            make.leading.equalTo(topView).offset(20)
            make.trailing.equalTo(topView).offset(-20)
            make.height.equalTo(20)
        }
        pinTextField.snp.makeConstraints { (make) in
            make.top.equalTo(secondaryLabel.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.centerX.equalTo(topView)
            make.height.equalTo(60)
        }
        pinTextFieldError.snp.makeConstraints { (make) in
            make.top.equalTo(pinTextField.snp.bottom)
            make.width.equalTo(250)
            make.centerX.equalTo(topView)
            make.height.equalTo(15)
        }

        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(view.layoutMarginsGuide).multipliedBy(0.50)
        }
        
        numPadView.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(60)
            make.leading.equalTo(bottomView).offset(20)
            make.trailing.equalTo(bottomView).offset(-20)
            make.bottom.equalTo(bottomView.layoutMarginsGuide.snp.bottom)
        }
        forgotMpin.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.trailing.equalTo(bottomView).offset(-20)
            make.height.equalTo(60)
            make.bottom.equalTo(numPadView.snp.top)
        }
    }

    @objc func forgotMpinClick() {
        // call API
        print("Forgot MPIN")
        self.setAnimate(msg: "Please wait")
        self.coordinator?.forgotMPINCoordinator()
    }
    
    func checkMPIN(pin: String) {
        if isChecking ?? false {
            if MPIN?.count == 0 {
                self.numPadView.btnBack.isHidden = false
                MPIN = pin
                pinTextField.text = nil
                pinTextField.clearText()
                numPadView.clearText()
            }else{
                if pin.count == maxPIN {
                   if MPIN == pin {
                        let customerId = self.customerData?.id ?? 0
                        self.viewModel?.saveMpin(MPIN: pin, customerId: String(describing:customerId) , token: tokenData?.accessToken ?? "")
                   }else {
                       self.wrongMpin()
                   }
                }
            }
        }else {
            print("CHECK MPIN : \(pin) == \(customerData?.mpin)")
            if pin == customerData?.mpin {
                
                //MARK: -FROM INACTIVE STATE
                if fromBackground {
//                    self.navigationController?.popViewController(animated: true)
                    self.coordinator?.gotoPreviousViewControllers()
                }else {
                    self.coordinator?.homeCoordinator()
                }
            }else {
                self.wronPinSetUp()
            }
        }
    }
    
    func wronPinSetUp() {
        if self.pinTextFieldError.isHidden == true {
            self.wrongMpin(msg: "Incorrect MPIN")
        }
    }

    
    func wrongMpin(msg: String? = "") {
        pinTextField.text = nil
        numPadView.clearText()
        self.pinTextField.clearText(isWrong: true)
        self.pinTextFieldError.text = msg
        self.pinTextFieldError.isHidden = false
    }
    
    @objc func btnBackClick() {
        MPIN = ""
        pinTextField.text = nil
        pinTextField.clearText()
        numPadView.clearText()
        clearedPin = false
        self.numPadView.btnBack.isHidden = true
    }
    
//    func runTimer() {
//       timer = Timer.scheduledTimer(timeInterval: 10, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTimer(){
//        seconds += 1
//        if tokenData?.expiresIn == seconds {
//MARK:-CHECKING EXPIRATION NG TOKEN
//        }
//    }
}
